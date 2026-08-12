import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/theme/icons.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';
import 'package:hci_mi5y_dormconnect/widgets/hybrid_create_sheet.dart';
import 'package:hci_mi5y_dormconnect/widgets/activity_toast.dart';

class NavigationBarWithLine extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const NavigationBarWithLine({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<NavigationBarWithLine> createState() => _NavigationBarWithLineState();
}

class _NavigationBarWithLineState extends State<NavigationBarWithLine>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;
  int _previousPage = 0;

  late final AnimationController _toastController;
  late final Animation<Offset> _toastAnimation;
  OverlayEntry? _toastOverlay;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo);
    _previousPage = widget.selectedIndex;

    _toastController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _toastAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _toastController, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant NavigationBarWithLine old) {
    super.didUpdateWidget(old);
    if (old.selectedIndex != widget.selectedIndex) {
      _previousPage = old.selectedIndex;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _toastController.dispose();
    super.dispose();
  }

  void _hideToast() {
    if (_toastOverlay == null) return;

    _toastController.reverse().whenComplete(() {
      _toastOverlay?.remove();
      _toastOverlay = null;
    });
  }

  void _showToast({
    required bool success,
    String? message,
    VoidCallback? onUndo,
  }) {
    _hideToast();

    _toastOverlay = OverlayEntry(
      builder:
          (ctx) => Positioned(
            top: MediaQuery.of(ctx).padding.top + 16,
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

    Future.delayed(const Duration(seconds: 3), _hideToast);
  }

  int _pageToNav(int page) => page >= 2 ? page + 1 : page;

  int _navToPage(int nav) => nav >= 3 ? nav - 1 : nav;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelMedium;
    final labelStyleSmaller = labelStyle?.copyWith(fontSize: 10);
    final media = MediaQuery.of(context);
    final iconSize = media.size.width * .05;
    final iconPadding = media.size.height * .0025;
    final underlineHeight = media.size.height * .004;
    final itemWidth = media.size.width / 5;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: media.size.height * .0006, color: Colors.grey),

        SizedBox(
          height: underlineHeight,
          child: AnimatedBuilder(
            animation: _curve,
            builder: (_, __) {
              final from = _pageToNav(_previousPage) * itemWidth;
              final to = _pageToNav(widget.selectedIndex) * itemWidth;
              final left = from + (to - from) * _curve.value;

              return Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: left + itemWidth * .2),
                  child: Container(
                    width: itemWidth * .6,
                    height: underlineHeight,
                    decoration: BoxDecoration(
                      color: AppColors.primary(context),
                      borderRadius: BorderRadius.circular(underlineHeight / 2),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: _pageToNav(widget.selectedIndex),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: AppColors.background(context),
            selectedItemColor: const Color(0xFF1b1b1b),
            unselectedItemColor: AppColors.unselectedIcon(context),
            selectedLabelStyle: labelStyleSmaller?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: labelStyleSmaller,

            onTap: (navIndex) async {
              if (navIndex == 2) {
                final result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const HybridCreateSheet(),
                );

                if (result == true) {
                  _showToast(success: true, message: 'Created successfully!');
                } else if (result is String) {
                  _showToast(success: false, message: result);
                }
                return;
              }

              widget.onItemTapped(_navToPage(navIndex));
            },

            // ─── items
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: iconPadding),
                  child:
                      widget.selectedIndex == 0
                          ? AppIcons.home_filled(
                            color: AppColors.selectedIcon(context),
                            size: iconSize,
                          )
                          : AppIcons.home_hollow(
                            color: AppColors.unselectedIcon(context),
                            size: iconSize,
                          ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: iconPadding),
                  child:
                      widget.selectedIndex == 1
                          ? AppIcons.explore_filled(
                            color: AppColors.selectedIcon(context),
                            size: iconSize,
                          )
                          : AppIcons.explore_hollow(
                            color: AppColors.unselectedIcon(context),
                            size: iconSize,
                          ),
                ),
                label: 'Discover',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4, left: 2, right: 2),
                  child: CircleAvatar(
                    backgroundColor: AppColors.primary(context),
                    radius: iconSize * 0.9,
                    child: Icon(
                      Icons.add,
                      size: iconSize * 1.1,
                      color: Colors.white,
                    ),
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: iconPadding),
                  child:
                      widget.selectedIndex == 2
                          ? AppIcons.group_filled(
                            color: AppColors.selectedIcon(context),
                            size: iconSize,
                          )
                          : AppIcons.group_hollow(
                            color: AppColors.unselectedIcon(context),
                            size: iconSize,
                          ),
                ),
                label: 'Communities',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: iconPadding),
                  child:
                      widget.selectedIndex == 3
                          ? AppIcons.person_filled(
                            color: AppColors.selectedIcon(context),
                            size: iconSize,
                          )
                          : AppIcons.person_hollow(
                            color: AppColors.unselectedIcon(context),
                            size: iconSize,
                          ),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
