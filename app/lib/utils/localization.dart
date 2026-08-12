import 'package:flutter/widgets.dart';
import '../l10n/generated/app_localizations.dart';

// see https://github.com/bizz84/localization_riverpod_flutter/blob/main/lib/src/localization/app_localizations_context.dart
// and https://codewithandrea.com/articles/flutter-localization-build-context-extension/#buildcontext-extension-to-the-rescue
extension LocalizedBuildContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
}

/// A simple placeholder that can be used to search all the hardcoded strings
/// in the code (useful to identify strings that need to be localized).
// Thanks to code with Andrea for this idea, https://github.com/bizz84/starter_architecture_flutter_firebase/blob/master/lib/src/localization/string_hardcoded.dart
extension LocalizedStringHardcoded on String {
  String get hardcoded => this;
}