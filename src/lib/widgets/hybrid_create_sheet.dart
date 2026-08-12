import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';
import 'package:hci_mi5y_dormconnect/widgets/segmented_control.dart';
import 'package:hci_mi5y_dormconnect/pages/home/create_activity_sheet.dart'
    as act;
import 'package:hci_mi5y_dormconnect/pages/communities/create_community_sheet.dart'
    as comm;
import 'package:hci_mi5y_dormconnect/theme/icons.dart';

class HybridCreateSheet extends StatefulWidget {
  const HybridCreateSheet({super.key});

  @override
  State<HybridCreateSheet> createState() => _HybridCreateSheetState();
}

class _HybridCreateSheetState extends State<HybridCreateSheet> {
  int _tab = 0;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    const double hFactor = 0.72;

    return FractionallySizedBox(
      heightFactor: hFactor,
      alignment: Alignment.bottomCenter,
      child: Material(
        color: AppColors.background(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const Text(
              'Create',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SegmentedControl(
                selectedIndex: _tab,
                onSegmentChanged: (i) => setState(() => _tab = i),
                labels: const ['Activity', 'Community'],
                iconWidgets: [
                  AppIcons.event(size: 22), // SvgPicture widget
                  AppIcons.group_filled(size: 22, color: Colors.black),
                ],
              ),
            ),

            const SizedBox(height: 12),

            if (_tab == 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(
                  value: (_page + 1) / 3,
                  color: AppColors.primary(context),
                  backgroundColor: Colors.grey.shade300,
                ),
              ),

            Expanded(
              child:
                  _tab == 0
                      ? act.CreateActivitySheet(
                        embedMode: true,
                        onPageMove: (p) => setState(() => _page = p),
                      )
                      : const comm.CreateCommunitySheet(embedMode: true),
            ),
          ],
        ),
      ),
    );
  }
}
