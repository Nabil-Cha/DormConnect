import 'package:flutter/material.dart';

class FaqsPage extends StatelessWidget {
  const FaqsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {'question': 'How do I reset my password?', 'answer': 'Go to Settings > Account Settings > Change Password.'},
      {'question': 'How do I contact support?', 'answer': 'Go to Help & Support > Contact Support.'},
      {'question': 'How can I switch themes?', 'answer': 'Go to Appearance & Theme > Theme Mode.'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('FAQs')),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final item = faqs[index];
          return ExpansionTile(
            title: Text(item['question']!),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(item['answer']!),
              ),
            ],
          );
        },
      ),
    );
  }
}
