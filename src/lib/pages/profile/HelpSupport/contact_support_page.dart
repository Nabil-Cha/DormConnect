import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Support')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email us'),
              onTap: () async {
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: 'support@yourapp.com',
                  query: 'subject=App Support',
                );
                // launchUrl(emailUri);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Call us'),
              onTap: () async {
                // final Uri telUri = Uri(scheme: 'tel', path: '+1234567890');
                // launchUrl(telUri);
              },
            ),
          ],
        ),
      ),
    );
  }
}
