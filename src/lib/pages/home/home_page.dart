import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:hci_mi5y_dormconnect/pages/home/widgets/activity_card/detailed_screen.dart';
import 'package:hci_mi5y_dormconnect/pages/home/widgets/featured_event_section.dart';
import 'package:hci_mi5y_dormconnect/pages/home/widgets/user_events_section.dart';
import 'package:hci_mi5y_dormconnect/models/activity/activity.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';
import 'package:hci_mi5y_dormconnect/pages/home/all_activities_page.dart';
import 'package:hci_mi5y_dormconnect/widgets/activity_toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onNavigateToDiscover});

  final VoidCallback? onNavigateToDiscover;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage>, TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  List<Activity> _activities = [];
  List<Activity> _savedActivities = [];
  bool _loading = false;
  bool _loadingSaved = false;
  String? _error;
  String? _username;

  // Toast animation controller
  late AnimationController _toastController;
  late Animation<Offset> _toastAnimation;
  OverlayEntry? _toastOverlay;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _checkAndShowUserDialog();
    _fetchActivities();
    _fetchSavedActivities(); // Add this line

    // Initialize toast animation
    _toastController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _toastAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _toastController, curve: Curves.easeOut));
  }
  @override
  void dispose() {
    _toastController.dispose();
    _hideToast();
    super.dispose();
  }

  void _showCustomToast(bool success, {String? message, VoidCallback? onUndo}) {
    _hideToast(); // Hide any existing toast

    _toastOverlay = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: SlideTransition(
              position: _toastAnimation,
              child: ActivityToast(
                success: success,
                message: message,
                onUndo: onUndo,
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_toastOverlay!);
    _toastController.forward();

    // Auto-hide after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _hideToast();
    });
  }

  void _hideToast() {
    if (_toastOverlay != null) {
      _toastController.reverse().then((_) {
        _toastOverlay?.remove();
        _toastOverlay = null;
      });
    }
  }

  Future<void> _fetchActivities() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username') ?? '';

      _username = username.isEmpty ? null : username;

      if (username.isEmpty) return;

      final List<dynamic> rows = await Supabase.instance.client
          .from('activities')
          .select()
          .contains('participants', [username])
          .order('start_date', ascending: true);

      _activities =
          rows
              .map((row) => Activity.fromMap(row as Map<String, dynamic>))
              .toList();
    } on PostgrestException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _fetchSavedActivities() async {
    print('=== _fetchSavedActivities called ===');
    setState(() {
      _loadingSaved = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedActivityIds = prefs.getStringList('saved_activity_ids') ?? [];

      print('Saved activity IDs from SharedPreferences: $savedActivityIds');

      if (savedActivityIds.isEmpty) {
        print('No saved activity IDs found');
        setState(() {
          _savedActivities = [];
        });
        return;
      }

      final intIds = savedActivityIds
          .map((id) => int.tryParse(id))
          .where((id) => id != null)
          .cast<int>()
          .toList();

      print('Parsed integer IDs: $intIds');

      if (intIds.isEmpty) {
        print('No valid integer IDs found');
        setState(() {
          _savedActivities = [];
        });
        return;
      }

      final List<dynamic> rows = await Supabase.instance.client
          .from('activities')
          .select()
          .inFilter('id', intIds)
          .order('start_date', ascending: true);

      print('Fetched ${rows.length} saved activities from database');

      _savedActivities = rows
          .map((row) => Activity.fromMap(row as Map<String, dynamic>))
          .toList();

      print('_savedActivities length: ${_savedActivities.length}');
      print('_savedActivities: $_savedActivities');

      // Log each saved activity
      for (int i = 0; i < _savedActivities.length; i++) {
        print('Saved Activity $i: ${_savedActivities[i].title} (ID: ${_savedActivities[i].id})');
      }

    } on PostgrestException catch (e) {
      print('PostgrestException in _fetchSavedActivities: ${e.message}');
      _savedActivities = [];
    } catch (e) {
      print('Error in _fetchSavedActivities: $e');
      _savedActivities = [];
    } finally {
      if (mounted) {
        setState(() => _loadingSaved = false);
        print('_savedActivities after setState: ${_savedActivities.length} items');
      }
    }
  }

  Future<void> _refreshData() async {
    await Future.wait([_fetchActivities(), _fetchSavedActivities()]);
  }

  Future<void> _checkAndShowUserDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (username == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showUserDialog();
      });
    }
  }

  // ─────────── NEW: Community Joining Logic ───────────
  Future<bool> _joinCommunityById(String communityId) async {
    // Must have a signed-in user
    if (_username == null || _username!.isEmpty) {
      _showCustomToast(false, message: 'Please sign in first');
      return false;
    }

    // Community ID must be numeric
    final int? parsedId = int.tryParse(communityId);
    if (parsedId == null) {
      _showCustomToast(false, message: 'Please enter a valid community ID');
      return false;
    }

    try {
      // Look up the community
      final communityData =
          await Supabase.instance.client
              .from('communities')
              .select('name, members')
              .eq('id', parsedId)
              .maybeSingle(); // returns `null` when not found

      if (communityData == null) {
        _showCustomToast(
          false,
          message: 'Community with ID $communityId not found',
        );
        return false;
      }

      final String communityName = communityData['name'] as String;
      final List<dynamic> current = communityData['members'] ?? [];

      // Already in the list → treat as success so the dialog can close
      if (current.contains(_username)) {
        _showCustomToast(
          false,
          message: 'You are already a member of "$communityName"',
        );
        return true;
      }

      // Add the user and update the row
      final updatedMembers = [...current, _username];
      await Supabase.instance.client
          .from('communities')
          .update({'members': updatedMembers})
          .eq('id', parsedId);

      _showCustomToast(true, message: 'Successfully joined "$communityName"!');
      return true;
    } on PostgrestException catch (e) {
      _showCustomToast(false, message: 'Error joining community: ${e.message}');
      return false; // <-- make sure to fail
    } catch (e) {
      _showCustomToast(
        false,
        message: 'Error joining community. Please try again.',
      );
      return false; // <-- make sure to fail
    }
  }

  Future<void> _showUserDialog() async {
    final usernameController = TextEditingController();
    bool isCheckingUsername = false;
    String? usernameError;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  title: const Text('Sign In'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          errorText: usernameError,
                          suffixIcon:
                              isCheckingUsername
                                  ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : null,
                        ),
                        onChanged: (value) {
                          if (usernameError != null) {
                            setDialogState(() {
                              usernameError = null;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showRegisterDialog();
                      },
                      child: const Text('Register'),
                    ),
                    TextButton(
                      onPressed:
                          isCheckingUsername
                              ? null
                              : () async {
                                final username = usernameController.text.trim();

                                if (username.isEmpty) {
                                  setDialogState(() {
                                    usernameError = 'Username cannot be empty';
                                  });
                                  return;
                                }

                                setDialogState(() {
                                  isCheckingUsername = true;
                                  usernameError = null;
                                });

                                try {
                                  final response = await Supabase
                                      .instance
                                      .client
                                      .from('users')
                                      .select('username')
                                      .eq('username', username)
                                      .limit(1);

                                  if (response.isEmpty) {
                                    setDialogState(() {
                                      isCheckingUsername = false;
                                      usernameError =
                                          'Username does not exist. Please register first.';
                                    });
                                    return;
                                  }

                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString('username', username);

                                  Navigator.of(context).pop();
                                  setState(() {});
                                  _fetchActivities();
                                } on PostgrestException catch (e) {
                                  setDialogState(() {
                                    isCheckingUsername = false;
                                    usernameError =
                                        'Error checking username: ${e.message}';
                                  });
                                } catch (e) {
                                  setDialogState(() {
                                    isCheckingUsername = false;
                                    usernameError =
                                        'Error checking username. Please try again.';
                                  });
                                }
                              },
                      child: Text(
                        isCheckingUsername ? 'Signing In...' : 'Sign In',
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

  Future<void> _showRegisterDialog() async {
    final usernameController = TextEditingController();
    final communityController = TextEditingController();
    bool isCheckingUsername = false;
    String? usernameError;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  title: const Text('Register'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ─── Username field ────────────────────────────────────────────────
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          errorText: usernameError,
                          suffixIcon:
                              isCheckingUsername
                                  ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : null,
                        ),
                        onChanged: (_) {
                          if (usernameError != null) {
                            setDialogState(() => usernameError = null);
                          }
                        },
                      ),
                      // ─── Community-ID field ────────────────────────────────────────────
                      TextField(
                        controller: communityController,
                        decoration: const InputDecoration(
                          labelText: 'Community ID',
                          hintText: 'Numeric ID from your dorm community',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                  // ─── Dialog buttons ────────────────────────────────────────────────────
                  actions: [
                    // Switch back to Sign-In
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showUserDialog();
                      },
                      child: const Text('Sign In'),
                    ),
                    // Register
                    TextButton(
                      onPressed:
                          isCheckingUsername
                              ? null
                              : () async {
                                final username = usernameController.text.trim();
                                final community =
                                    communityController.text.trim();
                                // Basic empty-field validation
                                if (username.isEmpty || community.isEmpty) {
                                  setDialogState(() {
                                    usernameError =
                                        username.isEmpty
                                            ? 'Username cannot be empty'
                                            : null;
                                  });
                                  return;
                                }
                                // Check community-ID is numeric
                                if (int.tryParse(community) == null) {
                                  _showCustomToast(
                                    false,
                                    message: 'Community ID must be a number',
                                  );
                                  return;
                                }

                                setDialogState(() {
                                  isCheckingUsername = true;
                                  usernameError = null;
                                });

                                try {
                                  // Does the username already exist?
                                  final nameExists =
                                      await Supabase.instance.client
                                          .from('users')
                                          .select('username')
                                          .eq('username', username)
                                          .maybeSingle();

                                  if (nameExists != null) {
                                    setDialogState(() {
                                      isCheckingUsername = false;
                                      usernameError =
                                          'Username already exists. Choose a different one.';
                                    });
                                    return;
                                  }

                                  // Insert user first …
                                  await Supabase.instance.client
                                      .from('users')
                                      .insert({'username': username});

                                  // … then try to join community
                                  _username = username; // needed by helper
                                  final joinedOk = await _joinCommunityById(
                                    community,
                                  ); // returns bool
                                  if (!joinedOk) {
                                    setDialogState(
                                      () => isCheckingUsername = false,
                                    );
                                    return; // helper already showed a toast
                                  }

                                  // Persist locally
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString('username', username);
                                  await prefs.setString('community', community);

                                  // All good – close dialog & refresh
                                  if (mounted) {
                                    Navigator.of(context).pop();
                                    setState(() {}); // rebuild greeting, etc.
                                    _fetchActivities(); // show user’s events
                                  }
                                } on PostgrestException catch (e) {
                                  setDialogState(() {
                                    isCheckingUsername = false;
                                    usernameError =
                                        'Error registering: ${e.message}';
                                  });
                                } catch (e) {
                                  setDialogState(() {
                                    isCheckingUsername = false;
                                    usernameError =
                                        'Error registering user. Please try again.';
                                  });
                                }
                              },
                      child: Text(
                        isCheckingUsername ? 'Registering…' : 'Register',
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

  String _formatDate(DateTime dt) => intl.DateFormat.MMMd().add_jm().format(dt);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _buildGreetingSection(int eventsTodayCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_username != null && _username!.isNotEmpty)
          Text(
            'Hey, $_username!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        const SizedBox(height: 4),
        Text(
          'You have $eventsTodayCount event(s) today',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  void _navigateToDiscoverPage() {
    widget.onNavigateToDiscover?.call();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }

    final now = DateTime.now();

    final upcoming =
        _activities.where((a) => a.startDate.isAfter(now)).toList()
          ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final past =
        _activities.where((a) => a.startDate.isBefore(now)).toList()
          ..sort((a, b) => b.startDate.compareTo(a.startDate));

    final eventsTodayCount =
        _activities.where((a) => _isSameDay(a.startDate, now)).length;

    final Activity? featured = upcoming.isNotEmpty ? upcoming.first : null;
    final upcomingList = upcoming.skip(1).take(5).toList();
    final pastList = past.take(5).toList();

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Container(
        child: CustomScrollView(
          key: const PageStorageKey('homeScroll'),
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              toolbarHeight: 50,
              backgroundColor: AppColors.background(context),
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: SafeArea(
                bottom: false,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'DormConnect',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),
                  _buildGreetingSection(eventsTodayCount),
                  const SizedBox(height: 20),
                  FeaturedEventSection(
                    activity: featured,
                    formatDate: _formatDate,
                    onTap: (act) => EventDetailScreen.navigateTo(context, act),
                    onFindEventsTap: _navigateToDiscoverPage,
                  ),
                  const SizedBox(height: 20),
                  UserEventsSection(
                    activities: upcomingList,
                    formatDate: _formatDate,
                    headerTitle: 'Your activities',
                    onFindEventsTap: _navigateToDiscoverPage,
                    // NEW: Add navigation callback
                    onSeeAllTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => AllActivitiesPage(
                                title: 'All Upcoming Activities',
                                activities: upcoming,
                                formatDate: _formatDate,
                              ),
                        ),
                      );
                    },
                    message: "You have no upcoming activities yet.",
                  ),
                  const SizedBox(height: 20),
                  if (_savedActivities.isNotEmpty)
                    UserEventsSection(
                      activities: _savedActivities,
                      formatDate: _formatDate,
                      headerTitle: 'Saved activities',
                      onFindEventsTap: _navigateToDiscoverPage,
                      onSeeAllTap: () {},
                      message: "You have no saved activities.",
                    ),
                  if (_savedActivities.isNotEmpty) const SizedBox(height: 20),
                  if (pastList.isNotEmpty)
                    UserEventsSection(
                      activities: pastList,
                      formatDate: _formatDate,
                      headerTitle: 'Past activities',
                      onFindEventsTap: _navigateToDiscoverPage,
                      // NEW: Add navigation callback
                      onSeeAllTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AllActivitiesPage(
                                  title: 'Past Activities',
                                  activities: past,
                                  formatDate: _formatDate,
                                ),
                          ),
                        );
                      },
                      message: "You have no upcoming activities yet.",
                    ),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
