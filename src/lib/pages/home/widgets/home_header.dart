import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';
import 'package:hci_mi5y_dormconnect/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeHeader extends StatelessWidget {
  final bool isSearching;

  const HomeHeader({
    super.key,
    required this.isSearching,
  });

  Future<String> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'Gast';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserName(),
      builder: (context, snapshot) {
        final userName = snapshot.data ?? 'Gast';
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                text: 'Hey, ',
                style: AppTheme().light(context).textTheme.headlineMedium,
                children: [
                  TextSpan(
                    text: userName,
                    style: AppTheme()
                        .light(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: AppColors.primary(context)),
                  ),
                  TextSpan(
                    text: '!',
                    style: AppTheme().light(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}