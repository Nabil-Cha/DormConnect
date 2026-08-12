import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hci_mi5y_dormconnect/widgets/navigation_bar/navigation_bar_classes.dart';
import 'package:hci_mi5y_dormconnect/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://mldhavqvdntcrfowiqjk.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sZGhhdnF2ZG50Y3Jmb3dpcWprIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgxOTc0MTEsImV4cCI6MjA2Mzc3MzQxMX0.vLoEx5481HydQNipSykTLaFm-3wLg86EEkEe_HkMCVQ',
    );
  } catch (e) {
    throw Exception('Supabase konnte nicht initialisiert werden: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme().light(context),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      home: FloatingNavBarPage(),
    );
  }
}