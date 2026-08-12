import 'package:flutter/material.dart';
import 'package:dormconnect/l10n/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'routing/router.dart';
import 'ui/core/theme/theme.dart';

void main() async {
  // is needed to set up Flutter's internal bindings (like the scheduler and platform channels) before any platform-specific or async operations are started. These bindings are crucial for Flutter to properly interact with native code, handle asynchronous operations, and manage the widget tree.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      restorationScopeId: 'app',
      localizationsDelegates: [
        AppLocalizations.delegate, 
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('de')],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      title: 'DormConnect',
      routerConfig: router, 
      debugShowCheckedModeBanner: false,
    );
  }
  }

