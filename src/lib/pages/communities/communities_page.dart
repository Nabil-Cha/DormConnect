import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hci_mi5y_dormconnect/models/community.dart';
import 'package:hci_mi5y_dormconnect/pages/communities/widgets/community_detail_screen.dart';
import 'package:hci_mi5y_dormconnect/pages/communities/widgets/community_section.dart';
import 'package:hci_mi5y_dormconnect/pages/communities/widgets/segment_header_delegate.dart';
import 'package:hci_mi5y_dormconnect/widgets/segmented_control.dart';
import 'package:hci_mi5y_dormconnect/pages/communities/widgets/community_header.dart';


import '../../theme/colors.dart';

class CommunitiesPage extends StatefulWidget {
  const CommunitiesPage({super.key});

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  static const _segmentKey = 'communities-selected-segment';
  int _selectedSegmentIndex = 0;
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  String? _currentUsername;
  List<Community> _allCommunities = [];

  String _searchQuery = '';
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _selectedSegmentIndex =
        PageStorage.of(context)?.readState(context, identifier: _segmentKey)
        as int? ??
            0;
    _initUserAndData();
  }

  Future<void> _initUserAndData() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUsername = prefs.getString('username');
    await _loadCommunities();
  }

  Future<void> _loadCommunities() async {
    try {
      final rows = await Supabase.instance.client
          .from('communities')
          .select()
          .order('member_count', ascending: false);

      if (!mounted) return;

      setState(() {
        _allCommunities =
            (rows as List<dynamic>)
                .map((e) => Community.fromMap(e as Map<String, dynamic>))
                .toList();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load communities: $e')));
    }
  }

  bool _isUserJoined(Community c) =>
      _currentUsername != null && c.members.contains(_currentUsername);

  List<Community> get _filteredExplore =>
      _allCommunities
          .where((c) => !_isUserJoined(c))
          .where(_searchFilter)
          .toList();

  List<Community> get _filteredJoined =>
      _allCommunities.where(_isUserJoined).where(_searchFilter).toList();

  bool _searchFilter(Community c) =>
      _searchQuery.isEmpty || c.name.toLowerCase().contains(_searchQuery);

  void _onSearchChangedDebounced(String text) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _searchQuery = text.toLowerCase());
      }
    });
  }

  void _openDetail(Community c) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder:
            (_, animation, __) => FadeTransition(
              opacity: animation,
              child: CommunityDetailScreen(community: c),
            ),
        transitionsBuilder:
            (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  void _changeSegment(int i) {
    PageStorage.of(context)?.writeState(context, i, identifier: _segmentKey);
    setState(() => _selectedSegmentIndex = i);
  }

  Future<void> _refresh() => _loadCommunities();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayed =
        _selectedSegmentIndex == 1 ? _filteredJoined : _filteredExplore;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          key: const PageStorageKey('communities-scroll'),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 80,
              collapsedHeight: 80,
              toolbarHeight: 80,
              backgroundColor: AppColors.background(context),
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: CommunitiesTopBar(
                    onSearchChanged: _onSearchChangedDebounced,
                  ),
                ),
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: SegmentHeaderDelegate(
                height: 56,
                child: Container(
                  color: AppColors.background(context),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SegmentedControl(
                    selectedIndex: _selectedSegmentIndex,
                    onSegmentChanged: _changeSegment,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                    displayed.isEmpty
                        ? Padding(
                          key: ValueKey('empty-$_selectedSegmentIndex'),
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Text(
                              _searchQuery.isEmpty
                                  ? (_selectedSegmentIndex == 1
                                      ? 'You have not joined any communities yet.'
                                      : 'No communities available.')
                                  : 'No results for "$_searchQuery".',
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                        : CommunitySection(
                      key: ValueKey('list-$_selectedSegmentIndex-$_searchQuery'),
                      title: _selectedSegmentIndex == 0
                          ? 'Explore Communities'
                          : 'Joined Communities',
                      description: _selectedSegmentIndex == 0
                          ? 'Discover and join new communities'
                          : 'Your active communities',
                      communities: displayed,
                      onCommunityTap: _openDetail,
                      onSeeAll: () {},
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
