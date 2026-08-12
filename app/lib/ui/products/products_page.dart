import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/localization.dart';
import '../../domain/product.dart';
import '../../routing/routes.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  // Sample product data
  static final List<Product> _products = [
    Product(id: 1, name: 'Laptop', price: 999.99),
    Product(id: 2, name: 'Smartphone', price: 699.99),
    Product(id: 3, name: 'Headphones', price: 199.99),
    // Add more products as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'.hardcoded),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            onTap: () => context.go(Routes.productDetailsPath(product.id)),
          );
        },
      ),
    );
  }
}