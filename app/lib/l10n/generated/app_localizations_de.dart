// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get home_title => 'Zählen';

  @override
  String get home_fab_tooltip => 'Erhöhen';

  @override
  String get settings_title => 'Einstellungen';

  @override
  String get settings_switch_mode => 'Dunkel';

  @override
  String get settings_text_name => 'Name';

  @override
  String get settings_text_name_hint_text => 'Gib deinen Namen ein';
}
