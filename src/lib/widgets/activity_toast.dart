import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';

class ActivityToast extends StatelessWidget {
  final bool          success;
  final String?       message;
  final VoidCallback? onUndo;

  const ActivityToast({
    super.key,
    required this.success,
    this.message,
    this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = success ? AppColors.primary(context) : Colors.red;
    final icon        = success ? Icons.check_circle : Icons.error;
    final msg         = message ?? (success ? 'Success!' : 'Error occurred');

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.25), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: borderColor, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                msg,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1b1b1b),
                ),
              ),
            ),
            if (onUndo != null)
              TextButton(
                onPressed: onUndo,
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary(context)),
                child: const Text('UNDO'),
              ),
          ],
        ),
      ),
    );
  }
}
