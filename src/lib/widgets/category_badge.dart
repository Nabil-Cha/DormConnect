import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryBadge extends StatelessWidget {
  const CategoryBadge({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  final SvgPicture icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final secondary = AppColors.secondary(context);
    final fill = AppColors.secondaryBackgroundColor(context);
    final borderColor = AppColors.secondaryAccent(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: icon,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: secondary,
            ),
          ),
        ],
      ),
    );
  }
}