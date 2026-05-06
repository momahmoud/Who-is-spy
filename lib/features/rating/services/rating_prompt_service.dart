import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/settings/services/rating_service.dart';
import 'package:url_launcher/url_launcher.dart';

/// Smart, capped two-step enjoyment → store / feedback prompt for retention.
///
/// Gates (all must pass):
/// - Successful rounds (guess correct / "level complete") ≥ 4
/// - Cold-start sessions ≥ 2
/// - Not failed this round (caller only invokes on success)
/// - Last ad shown ≥ 60s ago
/// - Same calendar day as last prompt → blocked
/// - Last prompt ≥ 4 days ago (unless never prompted)
/// - Total prompts shown < 3
/// - Dismiss-type actions < 3
/// - User has not already rated via this flow
class RatingPromptService {
  RatingPromptService._();

  static final RatingPromptService instance = RatingPromptService._();

  static const String _ratedKey = 'rating_prompt_user_rated';
  static const String _dismissCountKey = 'rating_prompt_dismiss_count';
  static const String _promptsShownKey = 'rating_prompt_prompts_shown_count';
  static const String _lastPromptMsKey = 'rating_prompt_last_prompt_ms';
  static const String _sessionCountKey = 'rating_prompt_session_count';
  static const String _successRoundsKey = 'rating_prompt_success_rounds';
  static const String _lastAdMsKey = 'rating_prompt_last_ad_ms';

  static const String _feedbackEmail = 'support@fluxy.com';

  static const int _minSuccessRounds = 4;
  static const int _minSessions = 2;
  static const int _maxPrompts = 3;
  static const int _maxDismissActions = 3;
  static const Duration _adCooldown = Duration(seconds: 60);
  static const Duration _betweenPrompts = Duration(days: 4);

  bool _dialogOpen = false;

  /// Call once per app cold start (before [tryShowAfterSuccessfulRound]).
  Future<void> recordColdStartSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int n = prefs.getInt(_sessionCountKey) ?? 0;
    await prefs.setInt(_sessionCountKey, n + 1);
  }

  /// Call when an interstitial or rewarded ad is actually shown (full screen).
  Future<void> recordAdShown() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastAdMsKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Call after a successful round (outsider guessed the secret word correctly).
  Future<void> recordSuccessfulRoundCompletion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int n = prefs.getInt(_successRoundsKey) ?? 0;
    await prefs.setInt(_successRoundsKey, n + 1);
  }

  Future<bool> shouldShowPrompt() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(_ratedKey) ?? false) return false;

    final int dismissCount = prefs.getInt(_dismissCountKey) ?? 0;
    if (dismissCount >= _maxDismissActions) return false;

    final int promptsShown = prefs.getInt(_promptsShownKey) ?? 0;
    if (promptsShown >= _maxPrompts) return false;

    final int sessions = prefs.getInt(_sessionCountKey) ?? 0;
    if (sessions < _minSessions) return false;

    final int success = prefs.getInt(_successRoundsKey) ?? 0;
    if (success < _minSuccessRounds) return false;

    final int? lastAdMs = prefs.getInt(_lastAdMsKey);
    if (lastAdMs != null) {
      final DateTime lastAd =
          DateTime.fromMillisecondsSinceEpoch(lastAdMs);
      if (DateTime.now().difference(lastAd) < _adCooldown) return false;
    }

    final int? lastPromptMs = prefs.getInt(_lastPromptMsKey);
    if (lastPromptMs != null) {
      final DateTime lastPrompt =
          DateTime.fromMillisecondsSinceEpoch(lastPromptMs);
      final DateTime now = DateTime.now();
      if (_isSameLocalDay(lastPrompt, now)) return false;
      if (now.difference(lastPrompt) < _betweenPrompts) return false;
    }

    return true;
  }

  /// Shows "Enjoying the game?" → store (positive) or feedback email (negative).
  Future<void> tryShowAfterSuccessfulRound() async {
    if (_dialogOpen) return;
    if (!await shouldShowPrompt()) return;

    final BuildContext? ctx = Get.context;
    if (ctx == null || !ctx.mounted) return;

    _dialogOpen = true;
    try {
      final bool? positive = await showDialog<bool>(
        context: ctx,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              context.localization.enjoyingGamePrompt,
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(context.localization.notReallyEnjoying),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(context.localization.yesLoveIt),
              ),
            ],
          );
        },
      );

      await _persistPromptShown();

      if (positive == true) {
        await _onPositive();
      } else {
        await _onNegativeOrDismissed(dismissViaBack: positive == null);
      }
    } finally {
      _dialogOpen = false;
    }
  }

  Future<void> _persistPromptShown() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int shown = prefs.getInt(_promptsShownKey) ?? 0;
    await prefs.setInt(_promptsShownKey, shown + 1);
    await prefs.setInt(_lastPromptMsKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _onPositive() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_ratedKey, true);
    await RatingService().openStoreDirectly();
  }

  Future<void> _onNegativeOrDismissed({required bool dismissViaBack}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int d = prefs.getInt(_dismissCountKey) ?? 0;
    await prefs.setInt(_dismissCountKey, d + 1);

    // Negative path opens feedback; pure dismiss (tap outside / back) only counts dismiss.
    if (!dismissViaBack) {
      final Uri uri = Uri.parse('mailto:$_feedbackEmail');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  bool _isSameLocalDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
