import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hci_mi5y_dormconnect/models/activity/activity.dart';
import 'package:hci_mi5y_dormconnect/pages/discover/widgets/discover_header.dart';
import 'package:hci_mi5y_dormconnect/pages/home/widgets/user_events_section.dart';
import 'package:hci_mi5y_dormconnect/pages/home/all_activities_page.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  List<Activity> _communityActivities = [];
  bool _isLoading = true;
  String? _error;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _username = prefs.getString('username') ?? '';

      if (_username.isNotEmpty) {
        await _fetchCommunityActivities();
      } else {
        setState(() {
          _error = 'Username not found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load user data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCommunityActivities() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final List<dynamic> communityRows = await Supabase.instance.client
          .from('communities')
          .select('id')
          .contains('members', [_username]);

      if (communityRows.isEmpty) {
        setState(() {
          _communityActivities = [];
          _isLoading = false;
        });
        return;
      }

      final List<int> communityIds =
          communityRows.map((row) => row['id'] as int).toList();

      final List<dynamic> activityRows = await Supabase.instance.client
          .from('activities')
          .select()
          .inFilter('community_id', communityIds)
          .not('participants', 'cs', '{$_username}')
          .eq('is_active', true)
          .gte('start_date', DateTime.now().toIso8601String())
          .order('start_date', ascending: true);

      final List<Activity> activities =
          activityRows
              .map((row) => Activity.fromMap(row as Map<String, dynamic>))
              .toList();

      setState(() {
        _communityActivities = activities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch activities: $e';
        _isLoading = false;
      });
    }
  }

  SliverToBoxAdapter _buildActivitiesSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            UserEventsSection(
              activities: _communityActivities.take(5).toList(),
              formatDate: _formatDate,
              headerTitle: 'From your communities',
              onSeeAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AllActivitiesPage(
                          title: 'All Community Activities',
                          activities: _communityActivities,
                          formatDate: _formatDate,
                        ),
                  ),
                );
              },
              showButton: false,
              message: "There are no events in your communities yet.",
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchCommunityActivities,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [_buildSimpleHeader(), _buildActivitiesSection()],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) => intl.DateFormat.MMMd().add_jm().format(dt);

  SliverToBoxAdapter _buildSimpleHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DiscoverHeader(),
      ),
    );
  }
}
