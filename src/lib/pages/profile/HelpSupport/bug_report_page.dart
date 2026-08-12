import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';

class BugReportPage extends StatefulWidget {
  const BugReportPage({super.key});

  @override
  State<BugReportPage> createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  final _descCtrl = TextEditingController();
  String _category = 'UI issue';

  final _categories = ['UI issue', 'Crash', 'Performance problem', 'Other'];

  void _submit() {
    if (_descCtrl.text.trim().isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bug report submitted. Thank you!')),
    );
    _descCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.background(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text('Report a Bug'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Found something that’s not working?',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: 16),

              /* —— category dropdown —— */
              Material(
                elevation: 1,
                shadowColor: Colors.black12,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      value: _category,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Category',
                      ),
                      items: _categories
                          .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => _category = v!),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /* —— description field —— */
              Material(
                elevation: 1,
                shadowColor: Colors.black12,
                borderRadius: BorderRadius.circular(12),
                child: TextField(
                  controller: _descCtrl,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Describe the issue…',
                    hintStyle:
                    TextStyle(color: AppColors.textSecondary(context)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /* —— submit button —— */
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
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
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
