import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/models/activity/activity.dart';
import 'package:hci_mi5y_dormconnect/pages/home/widgets/activity_card/card.dart';
import 'package:hci_mi5y_dormconnect/widgets/empty_illustration.dart';

class FeaturedEventSection extends StatelessWidget {
  final Activity? activity; // null if none
  final void Function(Activity) onTap;
  final String Function(DateTime) formatDate;
  final VoidCallback? onFindEventsTap; // NEW: Navigation callback

  const FeaturedEventSection({
    super.key,
    required this.activity,
    required this.onTap,
    required this.formatDate,
    this.onFindEventsTap,
  });

  @override
  Widget build(BuildContext context) {
    const cardHeight = 280.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your next activity',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),

        if (activity == null)
          EmptyIllustration(
            message: 'You have no upcoming activities yet.',
            ctaLabel: 'Find events',
            onCtaTap: onFindEventsTap,
            showButton: true,
          )
        else
          ActivityCard(
            activity: activity!,
            onTap: onTap,
            formatDate: formatDate,
            height: cardHeight,
          ),
      ],
    );
  }
}
