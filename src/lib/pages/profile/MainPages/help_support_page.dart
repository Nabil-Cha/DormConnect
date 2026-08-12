import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';
import '../HelpSupport/bug_report_page.dart';
import '../HelpSupport/contact_support_page.dart';
import '../HelpSupport/faqs_page.dart';
import '../HelpSupport/send_feedback_page.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  /* ───────── helper for chip background ───────── */
  Color _chipBg(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
          ? const Color(0xFF3A3A3A)
          : const Color(0xFF212121);

  Widget _buildHelpItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget destination,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            /* ─── dark circular icon chip ─── */
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _chipBg(context),          // ← matches Settings page
                shape: BoxShape.circle,
              ),
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
        title: Text(
          'Help & Support',
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Get Assistance',
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildHelpItem(
            context: context,
            icon: Icons.question_answer_outlined,
            title: 'FAQs',
            destination: const FaqsPage(),
          ),
          _buildHelpItem(
            context: context,
            icon: Icons.support_agent,
            title: 'Contact Support',
            destination: const ContactSupportPage(),
          ),
          _buildHelpItem(
            context: context,
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            destination: const SendFeedbackPage(),
          ),
          _buildHelpItem(
            context: context,
            icon: Icons.bug_report_outlined,
            title: 'Report a Bug',
            destination: const BugReportPage(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
