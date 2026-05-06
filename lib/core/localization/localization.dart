import 'package:salfah/core/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

extension LocalizedStrings on BuildContext {
  /// Returns single instance of [AppLocalization]
  /// Used instead of accessing and importing AppLocalizations at every page
  AppLocalization get localization => AppLocalization.of(this);
}
