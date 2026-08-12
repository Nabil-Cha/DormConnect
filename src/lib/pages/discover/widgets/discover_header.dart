import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/theme/theme.dart';

class DiscoverHeader extends StatelessWidget {
  const DiscoverHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discover',
              textAlign: TextAlign.left,
              style: AppTheme()
                  .light(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: const Color(0xFF1b1b1b)),
            ),
          ],
        ),
      ],
    );
  }
}