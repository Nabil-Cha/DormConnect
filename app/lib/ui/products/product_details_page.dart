import 'package:flutter/material.dart';
import 'package:dormconnect/utils/localization.dart';

class ProductDetailsPage extends StatelessWidget {
  final int id;

  const ProductDetailsPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$id'),
      ),
      body: Center(
        child: Text('Viewing details for product $id'.hardcoded),
      ),
    );
  }
}