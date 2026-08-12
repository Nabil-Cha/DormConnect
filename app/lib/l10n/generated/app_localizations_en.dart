// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home_title => 'Counter Example';

  @override
  String get home_fab_tooltip => 'Increment';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_switch_mode => 'Dark Mode';

  @override
  String get settings_text_name => 'Name';

  @override
  String get settings_text_name_hint_text => 'Enter your name';
}
