import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';

class SendFeedbackPage extends StatefulWidget {
  const SendFeedbackPage({super.key});

  @override
  State<SendFeedbackPage> createState() => _SendFeedbackPageState();
}

class _SendFeedbackPageState extends State<SendFeedbackPage> {
  final _controller = TextEditingController();

  void _sendFeedback() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your feedback!')),
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.background(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text('Send Feedback'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Let us know how we can improve:',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: 16),

              /* —— rounded card with TextField —— */
              Material(
                elevation: 1,
                shadowColor: Colors.black12,
                borderRadius: BorderRadius.circular(12),
                child: TextField(
                  controller: _controller,
                  maxLines: 6,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    hintText: 'Enter your feedback here…',
                    hintStyle: TextStyle(color: AppColors.textSecondary(context)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /* —— full-width primary button —— */
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _sendFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary(context),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  child: const Text('Send'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
