import 'package:flutter/material.dart';

class EmptyIllustration extends StatelessWidget {
  final String message;

  final String ctaLabel;

  final VoidCallback? onCtaTap;

  final bool showButton;

  const EmptyIllustration({
    super.key,
    required this.message,
    this.ctaLabel = '',
    this.onCtaTap,
    this.showButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      const SizedBox(height: 16),
      Icon(Icons.event_busy, size: 88, color: Colors.grey[300]),
      const SizedBox(height: 12),
      Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ];

    if (showButton) {
      children
        ..add(const SizedBox(height: 8))
        ..add(ElevatedButton(onPressed: onCtaTap, child: Text(ctaLabel)));
    }

    children.add(const SizedBox(height: 24));

    return Column(children: children);
  }
}
