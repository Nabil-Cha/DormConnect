import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:hci_mi5y_dormconnect/theme/icons.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';
import 'package:hci_mi5y_dormconnect/models/activity/activity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hci_mi5y_dormconnect/models/community.dart';
import 'package:hci_mi5y_dormconnect/pages/communities/widgets/community_detail_screen.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key, required this.activity});

  final Activity activity;

  static Future<void> navigateTo(BuildContext context, Activity activity) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => EventDetailScreen(activity: activity),
        transitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (_, animation, __, child) {
          final offsetAnim = Tween(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeIn)).animate(animation);
          return SlideTransition(position: offsetAnim, child: child);
        },
      ),
    );
  }

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen>
    with TickerProviderStateMixin {
  late Activity activity;
  bool isJoining = false;
  bool hasJoined = false;
  bool isSaved = false;
  bool isSaving = false;
  final SupabaseClient _client = Supabase.instance.client;
  String? username;

  late AnimationController _toastController;
  late Animation<Offset> _toastAnimation;
  OverlayEntry? _toastOverlay;

  @override
  void initState() {
    super.initState();
    activity = widget.activity;
    _loadUsernameAndStatus();

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

  Future<void> _loadUsernameAndStatus() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');

    if (username != null) {
      final hasJoinedActivity = activity.participants.contains(username);

      final savedActivityIds = prefs.getStringList('saved_activity_ids') ?? [];
      final isActivitySaved = savedActivityIds.contains(activity.id.toString());

      setState(() {
        hasJoined = hasJoinedActivity;
        isSaved = isActivitySaved;
      });
    }
  }

  Future<void> _handleSaveActivity() async {
    if (username == null) return;

    setState(() => isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedActivityIds = prefs.getStringList('saved_activity_ids') ?? [];
      final activityIdStr = activity.id.toString();

      if (isSaved) {
        savedActivityIds.remove(activityIdStr);
        await prefs.setStringList('saved_activity_ids', savedActivityIds);

        setState(() => isSaved = false);
        _showCustomToast(false, message: 'Activity removed from saved');
      } else {
        if (!savedActivityIds.contains(activityIdStr)) {
          savedActivityIds.add(activityIdStr);
          await prefs.setStringList('saved_activity_ids', savedActivityIds);
        }

        setState(() => isSaved = true);
        _showCustomToast(true, message: 'Activity saved successfully');
      }
    } catch (e) {
      _showCustomToast(false, message: 'Error saving activity');
    } finally {
      setState(() => isSaving = false);
    }
  }

  void _showCustomToast(bool success, {String? message, VoidCallback? onUndo}) {
    _hideToast();

    _toastOverlay = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: SlideTransition(
              position: _toastAnimation,
              child: _ActivityToast(
                success: success,
                message: message,
                onUndo: onUndo,
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_toastOverlay!);
    _toastController.forward();

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

  Future<void> _handleToggleParticipation() async {
    if (username == null) {
      _showCustomToast(false, message: 'Please sign in to join activities');
      return;
    }

    setState(() => isJoining = true);

    try {
      final response =
          await _client
              .from('activities')
              .select('participants')
              .eq('id', activity.id)
              .single();

      final participants = List<String>.from(response['participants'] ?? []);

      final isAlreadyJoined = participants.contains(username);

      final updatedParticipants =
          isAlreadyJoined
              ? participants.where((p) => p != username).toList()
              : [...participants, username!];

      await _client
          .from('activities')
          .update({'participants': updatedParticipants})
          .eq('id', activity.id);

      setState(() {
        hasJoined = !isAlreadyJoined;
        activity =
            isAlreadyJoined
                ? activity.removeParticipant(username!)
                : activity.addParticipant(username!);
      });

      _showCustomToast(
        !isAlreadyJoined,
        message:
            !isAlreadyJoined
                ? 'You joined the activity!'
                : 'You left the activity.',
        onUndo: isAlreadyJoined ? () => _handleToggleParticipation() : null,
      );
    } catch (e) {
      _showCustomToast(false, message: 'Error updating participation');
    } finally {
      setState(() => isJoining = false);
    }
  }

  Future<void> _navigateToCommunity() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final response =
          await _client
              .from('communities')
              .select()
              .eq('name', activity.community)
              .single();

      Navigator.of(context).pop();

      final community = Community.fromMap(response);

      await CommunityDetailScreen.navigateTo(
        context,
        community,
        onMembershipChanged: (communityId, isJoined) {},
      );
    } catch (e) {
      Navigator.of(context).pop();

      _showCustomToast(false, message: 'Error loading community details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = activity;

    final String dateStr =
        a.startDate != null
            ? intl.DateFormat.MMMd().add_jm().format(a.startDate!)
            : 'TBA';
    final String participantsStr =
        '${a.participantCount}/${a.maxParticipants ?? '∞'}';

    ImageProvider heroImage =
        (a.image?.startsWith('http') ?? false)
            ? NetworkImage(a.image!)
            : (a.image != null
                ? AssetImage(a.image!)
                : const NetworkImage(
                  'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=2400&q=80',
                ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                toolbarHeight: 70,
                pinned: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                flexibleSpace: Hero(
                  tag: a.id,
                  child: Image(image: heroImage, fit: BoxFit.cover),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.title,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 5),

                      Row(
                        children: [
                          AppIcons.group_filled(
                            color: AppColors.textTertiary(context),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: _navigateToCommunity,
                            borderRadius: BorderRadius.circular(4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Organized by ',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textTertiary(context),
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  a.community,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary(context),
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.chevron_right,
                                  size: 16,
                                  color: AppColors.primary(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AppIcons.calendar(
                                  color: AppColors.primary(context),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  dateStr,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                AppIcons.location(
                                  color: AppColors.primary(context),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    a.location ?? 'Unknown location',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSecondary(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                AppIcons.group_filled(
                                  color: AppColors.primary(context),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$participantsStr people attending',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Activity Description',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        a.description.isEmpty
                            ? 'No description provided.'
                            : a.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary(context),
                          height: 1.5,
                        ),
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 100,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed:
                        (activity.isFull && !hasJoined) || isJoining
                            ? null
                            : _handleToggleParticipation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          hasJoined
                              ? AppColors.primary(context)
                              : AppColors.lightJoinEvent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child:
                        isJoining
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              hasJoined ? 'Leave Activity' : 'Join Activity',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : _handleSaveActivity,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSaved ? AppColors.primary(context) : Colors.white,
                      foregroundColor:
                          isSaved ? Colors.white : AppColors.primary(context),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                          color: AppColors.primary(context),
                          width: 2,
                        ),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child:
                        isSaving
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    isSaved
                                        ? Colors.white
                                        : AppColors.primary(context),
                              ),
                            )
                            : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSaved
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      isSaved
                                          ? Colors.white
                                          : AppColors.primary(context),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isSaved ? 'Saved' : 'Save',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityToast extends StatelessWidget {
  final bool success;
  final String? message;
  final VoidCallback? onUndo;

  const _ActivityToast({
    super.key,
    required this.success,
    this.message,
    this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = success ? AppColors.primary(context) : Colors.red;
    final displayMessage = message ?? (success ? 'Success!' : 'Error occurred');
    final icon = success ? Icons.check_circle : Icons.error;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: borderColor, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1b1b1b),
                ),
              ),
            ),
            if (onUndo != null)
              TextButton(
                onPressed: onUndo,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary(context),
                ),
                child: const Text('UNDO'),
              ),
          ],
        ),
      ),
    );
  }
}
