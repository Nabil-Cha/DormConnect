import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart'; // ← keep if you use it
import '../About/appversion_buildnumber_page.dart';
import '../About/developer_info_page.dart';
import '../About/open_source_licenses_page.dart';
import '../About/privacy_policy_page.dart';
import '../About/terms_of_service_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  /* —— dark circular chip colour —— */
  Color _chipBg(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
          ? const Color(0xFF3A3A3A)
          : const Color(0xFF212121);

  Widget _buildAboutItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget destination,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => destination)),
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            /* —— icon chip —— */
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: _chipBg(context), shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.textPrimary(context)),
        centerTitle: true,
        title: Text(
          'About',
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: ListView(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'App Info',
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildAboutItem(
            context    : context,
            icon       : Icons.info_outline,
            title      : 'App version & build number',
            destination: const AppVersionBuildNumberPage(),
          ),
          _buildAboutItem(
            context    : context,
            icon       : Icons.developer_mode,
            title      : 'Developer info',
            destination: const DeveloperInfoPage(),
          ),
          _buildAboutItem(
            context    : context,
            icon       : Icons.privacy_tip_outlined,
            title      : 'Privacy Policy',
            destination: const PrivacyPolicyPage(),
          ),
          _buildAboutItem(
            context    : context,
            icon       : Icons.description_outlined,
            title      : 'Terms of Service',
            destination: const TermsOfServicePage(),
          ),
          _buildAboutItem(
            context    : context,
            icon       : Icons.code,
            title      : 'Open-source licenses',
            destination: const OpenSourceLicensesPage(),
          ),
          const SizedBox(height: 24),
        ],
      ),

      /* —— keep the bottom nav bar visible (profile tab highlighted) —— */

    );
  }
}
