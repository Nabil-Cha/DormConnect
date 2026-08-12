import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hci_mi5y_dormconnect/models/community.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';
import 'package:hci_mi5y_dormconnect/theme/icons.dart';

typedef MembershipChangedCallback =
    void Function(String communityId, bool isJoined);

class CommunityDetailScreen extends StatefulWidget {
  final Community community;
  final MembershipChangedCallback? onMembershipChanged;

  const CommunityDetailScreen({
    super.key,
    required this.community,
    this.onMembershipChanged,
  });

  static Future<void> navigateTo(
    BuildContext context,
    Community community, {
    MembershipChangedCallback? onMembershipChanged,
  }) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (_, __, ___) => CommunityDetailScreen(
              community: community,
              onMembershipChanged: onMembershipChanged,
            ),
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
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen>
    with SingleTickerProviderStateMixin {
  late Community _community;
  late String _username;
  bool _isMember = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _community = widget.community;
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 'test';

    setState(() {
      _username = username;
      _isMember = _community.members.contains(_username);
    });
  }

  Future<void> _toggleMembership() async {
    setState(() => _isLoading = true);

    final updatedMembers = List<String>.from(_community.members);

    if (_isMember) {
      updatedMembers.remove(_username);
    } else {
      updatedMembers.add(_username);
    }

    try {
      await Supabase.instance.client
          .from('communities')
          .update({'members': updatedMembers})
          .eq('id', _community.id);

      final updated =
          await Supabase.instance.client
              .from('communities')
              .select()
              .eq('id', _community.id)
              .single();

      setState(() {
        _community = Community.fromMap(updated);
        _isMember = _community.members.contains(_username);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Aktualisieren: $error')),
      );
    } finally {
      setState(() => _isLoading = false);
    }

    _showMembershipSnackBar(nowMember: _isMember);
  }

  void _showMembershipSnackBar({required bool nowMember}) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );
    final curved = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeIn,
    );

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder:
          (_) => Positioned(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).padding.top + 16,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(curved),
              child: _MembershipToast(
                nowMember: nowMember,
                onUndo: () {
                  _toggleMembership();
                  controller.reverse();
                },
              ),
            ),
          ),
    );

    overlay.insert(entry);
    controller.forward();

    Future.delayed(const Duration(seconds: 3), () async {
      await controller.reverse();
      entry.remove();
      controller.dispose();
    });
  }

  ImageProvider _imageProvider(String? url) {
    if (url == null || url.isEmpty) {
      return const NetworkImage(
        'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=2400&q=80',
      );
    }
    return url.startsWith('http')
        ? NetworkImage(url)
        : AssetImage(url) as ImageProvider;
  }

  @override
  Widget build(BuildContext context) {
    final c = _community;

    final String foundedStr =
        '${c.createdOn.year}-${c.createdOn.month.toString().padLeft(2, '0')}-${c.createdOn.day.toString().padLeft(2, '0')}';
    final String membersStr = '${c.memberCount} members';

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
                  tag: 'community-image-${c.id}',
                  child: Image(
                    image: _imageProvider(c.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.name,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1b1b1b),
                        ),
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
                                AppIcons.location(
                                  color: AppColors.primary(context),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    c.location,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFF1b1b1b),
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
                                  membersStr,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF1b1b1b),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                AppIcons.calendar(
                                  color: AppColors.primary(context),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Founded $foundedStr',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF1b1b1b),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

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
                        _isLoading
                            ? null
                            : () async {
                              await _toggleMembership();
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final List<String> communities =
                                  prefs.getStringList('communities') ?? [];
                              final String communityEntry =
                                  '${_community.id}:${_community.name}';

                              if (_isMember) {
                                if (!communities.contains(communityEntry)) {
                                  communities.add(communityEntry);
                                  await prefs.setStringList(
                                    'communities',
                                    communities,
                                  );
                                }
                              } else {
                                communities.removeWhere(
                                  (entry) =>
                                      entry.split(':').first == _community.id,
                                );
                                await prefs.setStringList(
                                  'communities',
                                  communities,
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isMember ? Colors.red : AppColors.primary(context),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              _isMember ? 'Leave Community' : 'Join Community',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
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

class MembershipToast {
  static void show(
    BuildContext context, {
    required bool nowMember,
    VoidCallback? onUndo,
    required TickerProvider vsync,
  }) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: vsync,
    );
    final curved = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeIn,
    );

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder:
          (_) => Positioned(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).padding.top + 16,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(curved),
              child: _MembershipToast(
                nowMember: nowMember,
                onUndo:
                    onUndo != null
                        ? () {
                          onUndo();
                          controller.reverse();
                        }
                        : null,
              ),
            ),
          ),
    );

    overlay.insert(entry);
    controller.forward();

    Future.delayed(const Duration(seconds: 3), () async {
      await controller.reverse();
      entry.remove();
      controller.dispose();
    });
  }
}

class _MembershipToast extends StatelessWidget {
  final bool nowMember;
  final VoidCallback? onUndo;

  const _MembershipToast({super.key, required this.nowMember, this.onUndo});

  @override
  Widget build(BuildContext context) {
    final borderColor = nowMember ? AppColors.primary(context) : Colors.red;
    final text =
        nowMember
            ? 'You\'ve joined the community'
            : 'You\'ve left the community';
    final icon = nowMember ? Icons.check_circle : Icons.logout;

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
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1b1b1b),
                ),
              ),
            ),
            if (!nowMember && onUndo != null)
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
