import 'package:flutter/material.dart';

class SegmentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  SegmentHeaderDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SegmentHeaderDelegate oldDelegate) => false;
}