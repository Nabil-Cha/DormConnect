import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';
import 'package:hci_mi5y_dormconnect/theme/icons.dart';

class SegmentedControl extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onSegmentChanged;

  final List<String>? labels;

  final List<IconData>? icons;

  final List<Widget>? iconWidgets;

  const SegmentedControl({
    super.key,
    required this.selectedIndex,
    required this.onSegmentChanged,
    this.labels,
    this.icons,
    this.iconWidgets,
  }) : assert(
         icons == null || iconWidgets == null,
         'Use either "icons" OR "iconWidgets", not both.',
       ),
       assert(
         icons == null || icons.length == 2,
         '"icons" must contain exactly 2 elements.',
       ),
       assert(
         iconWidgets == null || iconWidgets.length == 2,
         '"iconWidgets" must contain exactly 2 elements.',
       );

  @override
  State<SegmentedControl> createState() => _SegmentedControlState();
}

class _SegmentedControlState extends State<SegmentedControl>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _anim,
    curve: Curves.easeOutExpo,
  );

  late int _current;
  late int _previous;
  late List<String> _labels;

  @override
  void initState() {
    super.initState();
    _current = widget.selectedIndex;
    _previous = widget.selectedIndex;
    _labels = widget.labels ?? const ['Explore', 'Joined'];
  }

  @override
  void didUpdateWidget(covariant SegmentedControl old) {
    super.didUpdateWidget(old);
    if (old.selectedIndex != widget.selectedIndex) {
      _previous = _current;
      _current = widget.selectedIndex;
      _anim.forward(from: 0);
    }
  }

  void _handleTap(int i) {
    if (i == _current) return;
    setState(() {
      _previous = _current;
      _current = i;
    });
    _anim.forward(from: 0);
    widget.onSegmentChanged(i);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Widget _bundledIcon(int index, bool selected) {
    if (index == 0) {
      return selected
          ? AppIcons.explore_filled(color: const Color(0xFF1b1b1b), size: 22)
          : AppIcons.explore_hollow(color: const Color(0xFF1b1b1b), size: 22);
    }
    return selected
        ? AppIcons.home_filled(color: const Color(0xFF1b1b1b), size: 22)
        : AppIcons.home_hollow(color: const Color(0xFF1b1b1b), size: 22);
  }

  @override
  Widget build(BuildContext context) {
    final double fullWidth = MediaQuery.of(context).size.width - 32;
    final double segmentW = fullWidth / _labels.length;

    return Column(
      children: [
        Row(
          children: List.generate(_labels.length, (i) {
            final bool selected = i == _current;

            Widget iconWidget;
            if (widget.iconWidgets != null) {
              iconWidget = widget.iconWidgets![i];
            } else if (widget.icons != null) {
              iconWidget = Icon(
                widget.icons![i],
                size: 22,
                color: const Color(0xFF1b1b1b),
              );
            } else {
              iconWidget = _bundledIcon(i, selected);
            }

            return Expanded(
              child: InkWell(
                onTap: () => _handleTap(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      iconWidget,
                      const SizedBox(width: 4),
                      Text(
                        _labels[i],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(
                            0xFF1b1b1b,
                          ).withOpacity(selected ? 1 : .6),
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),

        SizedBox(
          height: 2,
          child: AnimatedBuilder(
            animation: _curve,
            builder: (_, __) {
              final double from = _previous * segmentW;
              final double to = _current * segmentW;
              final double left = from + (to - from) * _curve.value;

              const double iconW = 22.0;
              const double gap = 4.0;
              final textPainter = TextPainter(
                text: TextSpan(
                  text: _labels[_current],
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                textDirection: TextDirection.ltr,
              )..layout();
              final double underlineW = iconW + gap + textPainter.width;

              return Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: left + (segmentW - underlineW) / 2,
                  ),
                  child: Container(
                    width: underlineW,
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.primary(context),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
