import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/models/activity/activity.dart';
import 'package:hci_mi5y_dormconnect/theme/theme.dart';
import 'package:hci_mi5y_dormconnect/pages/home/widgets/activity_card/card.dart';
import 'package:hci_mi5y_dormconnect/pages/home/widgets/activity_card/detailed_screen.dart';
import 'package:hci_mi5y_dormconnect/widgets/empty_illustration.dart';

class UserEventsSection extends StatelessWidget {
  final List<Activity> activities;
  final String Function(DateTime) formatDate;
  final VoidCallback? onSeeAllTap;
  final String headerTitle;
  final VoidCallback? onFindEventsTap;
  final bool showButton;
  final String message;

  const UserEventsSection({
    super.key,
    required this.activities,
    required this.formatDate,
    required this.headerTitle,
    this.onSeeAllTap,
    this.onFindEventsTap,
    this.showButton = true,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserEventsSectionHeader(title: headerTitle, onSeeAllTap: onSeeAllTap),
        const SizedBox(height: 8),
        activities.isEmpty
            ? EmptyIllustration(
              message: message,
              ctaLabel: 'Find events',
              onCtaTap: onFindEventsTap,
              showButton: showButton,
            )
            : UserEventsHorizontalList(
              activities: activities,
              formatDate: formatDate,
            ),
      ],
    );
  }
}

class UserEventsSectionHeader extends StatelessWidget {
  final VoidCallback? onSeeAllTap;
  final String title;

  const UserEventsSectionHeader({
    super.key,
    this.onSeeAllTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        GestureDetector(
          onTap: onSeeAllTap ?? () {},
          child: Text(
            'See all',
            style: AppTheme().light(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}

class UserEventsHorizontalList extends StatefulWidget {
  const UserEventsHorizontalList({
    super.key,
    required this.activities,
    required this.formatDate,
  });

  final List<Activity> activities;
  final String Function(DateTime) formatDate;

  @override
  State<UserEventsHorizontalList> createState() =>
      _UserEventsHorizontalListState();
}

class _UserEventsHorizontalListState extends State<UserEventsHorizontalList>
    with AutomaticKeepAliveClientMixin<UserEventsHorizontalList> {
  late final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    const cardHeight = 350.0;
    final screenW = MediaQuery.of(context).size.width;

    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        key: const PageStorageKey('userEventsHorizontalList'),
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        clipBehavior: Clip.none,
        itemCount: widget.activities.length,
        itemBuilder: (context, index) {
          final activity = widget.activities[index];

          return ActivityCard(
            activity: activity,
            formatDate: widget.formatDate,
            width: screenW * (237 / 396),
            height: cardHeight,
            margin: EdgeInsets.only(right: 16, left: index == 0 ? 0 : 0),
            onTap: (act) => EventDetailScreen.navigateTo(context, act),
          );
        },
      ),
    );
  }
}
