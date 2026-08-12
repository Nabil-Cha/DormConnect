import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/models/community.dart';
import 'package:hci_mi5y_dormconnect/theme/theme.dart';
import 'community_card.dart';

class CommunitySection extends StatelessWidget {
  final String title;
  final String description;
  final List<Community> communities;
  final VoidCallback onSeeAll;
  final void Function(Community) onCommunityTap;
  final int? maxItems;

  const CommunitySection({
    super.key,
    required this.title,
    required this.description,
    required this.communities,
    required this.onSeeAll,
    required this.onCommunityTap,
    this.maxItems,
  });

  Widget _buildSectionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: AppTheme()
                    .light(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Opacity(
            opacity: 0.8,
            child: Text(
              description,
              style: AppTheme()
                  .light(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalList(BuildContext context) {
    final displayed =
        maxItems != null ? communities.take(maxItems!).toList() : communities;

    if (displayed.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          children: [
            Icon(Icons.groups_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No communities found',
              style: AppTheme()
                  .light(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children:
            displayed.asMap().entries.map((entry) {
              final index = entry.key;
              final community = entry.value;

              return Column(
                children: [
                  CommunityCard(community: community, onTap: onCommunityTap),
                  if (index < displayed.length - 1) const SizedBox(height: 12),
                ],
              );
            }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildSectionHeader(context),
      const SizedBox(height: 8),
      _buildVerticalList(context),
    ],
  );
}
