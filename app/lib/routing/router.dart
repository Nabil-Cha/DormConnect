import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ui/core/ui/scaffold_with_navigation_bar.dart';
import '../ui/home/home_page.dart';
import '../ui/products/product_details_page.dart';
import '../ui/products/products_page.dart';
import '../ui/settings/settings_page.dart';
import 'routes.dart';

// based on https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart

// root navigator key and for each entry in the bottom navigation bar a navigator key
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');
final _productsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'products');
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'homeBranch');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavigationBar(navigationShell: navigationShell);
      },
      branches: _bottomNavBranches,
    ),
  ],
);

final _bottomNavBranches = [
  StatefulShellBranch(
    navigatorKey: _homeNavigatorKey,
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomePage(),),
    ],),
    StatefulShellBranch(
    navigatorKey: _productsNavigatorKey,
    routes: [
      GoRoute(
        path: Routes.products,
        builder: (context, state) => const ProductsPage(),
        routes: [
          GoRoute(
            path: Routes.productDetails,
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              // more transitions see https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/transition_animations.dart
              return CustomTransitionPage(
                child: ProductDetailsPage(id: int.parse(id)),
                transitionsBuilder:
                    (_, animation, _, child) =>
                        ScaleTransition(scale: animation, child: child),
              );
            }
          ),
        ],
      ),
    ],
  ),
  StatefulShellBranch(
    navigatorKey: _settingsNavigatorKey,
    routes: [
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  ),
];
