import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/models/activity/activity.dart';
import 'package:hci_mi5y_dormconnect/pages/home/widgets/activity_card/detailed_screen.dart';

class AllActivitiesPage extends StatelessWidget {
  final String title;
  final List<Activity> activities;
  final String Function(DateTime) formatDate;

  const AllActivitiesPage({
    Key? key,
    required this.title,
    required this.activities,
    required this.formatDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(child: Text('No activities found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.separated(
        itemCount: activities.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            title: Text(activity.title),
            subtitle: Text(formatDate(activity.startDate)),
            onTap: () => EventDetailScreen.navigateTo(context, activity),
          );
        },
      ),
    );
  }
}
