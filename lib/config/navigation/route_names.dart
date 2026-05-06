import 'package:flutter/foundation.dart' show immutable;

@immutable
class RouteNames {
  const RouteNames._();

  /// Region Of App Routes
  static String get splash => '/splash';

  static String get home => '/';

  static String get intro => '/intro';
  static String get players => '/players';
  static String get gameRound => '/gameRound';
  static String get roundFinish => '/roundFinish';

  static String get settings => '/settings';

  /// End Region Of App Routes
}
