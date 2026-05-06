import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:salfah/config/navigation/route_names.dart';
import 'package:salfah/core/config/economy_config.dart';
import 'package:salfah/core/const/const_strings.dart';
import 'package:salfah/core/helpers/app_helper_functions.dart';
import 'package:salfah/features/ads/presentation/controller/coins_controller.dart';
import 'package:salfah/features/ads/services/ads_service.dart';
import 'package:salfah/features/monetization/services/interstitial_policy_service.dart';
import 'package:salfah/features/monetization/services/monetization_bonus_service.dart';
import 'package:salfah/features/rating/services/rating_prompt_service.dart';
import 'package:get/get.dart';

/// Controller responsible for handling the logic of the **round finish screen**
///
/// Responsibilities:
/// - Displaying result of the final guess
/// - Playing success / fail sounds
/// - Generating random item options
/// - Awarding coins per round (+10) and showing interstitial after each round
/// - Restarting the game or changing category
class RoundFinishController extends GetxController {
  final AdsService _adsService = Get.find<AdsService>();
  final CoinsController coinsController = Get.find<CoinsController>();

  /// Map of players and their scores
  late Map<String, int> players;

  /// The player who was outside the round
  late String outsidePlayer;

  /// The correct item (secret word)
  late String item;

  /// Current game category
  late String category;

  /// Controls visibility of result section
  bool resultShow = false;

  /// Controls visibility of statistics section
  bool statShow = false;

  /// Controls visibility of end-of-round section (after interstitial)
  bool endOfRoundShow = false;

  /// The item that was selected by the user
  String? selectedItem;

  /// List of items shown as guessing options
  List<String> items = <String>[];

  /// Audio player used for success/failure sounds
  final AudioPlayer _player = AudioPlayer();

  /// Called when the controller is initialized
  ///
  /// - Reads navigation arguments
  /// - Initializes game data
  /// - Generates random guessing items
  @override
  void onInit() {
    super.onInit();

    final Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;

    players = Map<String, int>.from(args['players'] as Map<String, int>);
    outsidePlayer = args['outsidePlayer'] as String;
    item = args['item'] as String;
    category = args['category'] as String;

    _generateItems();
    unawaited(_onRoundFinished());
  }

  /// Award coins for finishing round. Interstitial is shown when user taps Next.
  Future<void> _onRoundFinished() async {
    await InterstitialPolicyService.recordRoundFinished();
    await MonetizationBonusService.onRoundFinishedForSessionBonus();
    final EconomyConfig config = await EconomyConfig.load();
    await coinsController.addCoins(
      config.coinsPerRound,
      reason: 'round_finish',
    );
  }

  /// Called when user taps Next on results. Shows interstitial then end-of-round view.
  Future<void> onNextFromResults() async {
    await _adsService.showInterstitial(useInterstitialPolicy: false);
    endOfRoundShow = true;
    update();
  }

  /// Navigate to players screen to change players. Passes current category
  /// since PlayersController expects it.
  Future<void> goToChangePlayers() async {
    if (Get.context?.mounted ?? false) {
      await Get.offAllNamed<void>(RouteNames.players, arguments: category);
    }
  }

  /// Generates a randomized list of guessing items
  ///
  /// - Loads category items from local JSON
  /// - Ensures the correct item is always included
  /// - Avoids duplicates
  /// - Limits total options to 8
  ///
  Future<void> _generateItems() async {
    await AppHelperFunctions().load(
      Get.locale ?? const Locale(AppStrings.arabicLang),
    );

    items = AppHelperFunctions().getRandomOptions(
      categoryKey: category,
      correctItem: item,
    );

    update();
  }

  /// Handles user selection of an item
  ///
  /// - Shows result
  /// - Updates score if correct
  /// - Plays success or failure sound
  Future<void> selectItem(String selected) async {
    selectedItem = selected;
    resultShow = true;

    if (selected == item) {
      players.update(outsidePlayer, (int v) => v + 1);
      await _player.play(AssetSource('sound/success.wav'));
      unawaited(RatingPromptService.instance.recordSuccessfulRoundCompletion());
      SchedulerBinding.instance.addPostFrameCallback((_) {
        unawaited(RatingPromptService.instance.tryShowAfterSuccessfulRound());
      });
    } else {
      await _player.play(AssetSource('sound/fail.wav'));
    }

    update();
  }

  /// Shows the statistics section and preloads interstitial in background
  void showStats() {
    statShow = true;
    _adsService.preloadInterstitial();
    update();
  }

  /// Navigates back to the home screen to change category
  Future<void> changeCategory() async {
    if (Get.context?.mounted ?? false) {
      await Get.offAllNamed<void>(RouteNames.home);
    }
  }

  /// Interstitial then home (end-of-round explicit exit).
  Future<void> goToHomePageAfterInterstitial() async {
    await _adsService.showInterstitial(useInterstitialPolicy: false);
    await changeCategory();
  }

  /// Starts a new round with:
  /// - Same players
  /// - Same category
  /// - New random item
  /// - New random outside player
  Future<void> playAgain() async {
    final String newItem = AppHelperFunctions().getRandomItem(category);
    final String newOutside = players.keys.elementAt(
      Random().nextInt(players.length),
    );

    if (Get.context?.mounted ?? false) {
      await Get.offAllNamed<void>(
        RouteNames.gameRound,
        arguments: <String, Object>{
          'players': players,
          'outsidePlayer': newOutside,
          'category': category,
          'item': newItem,
        },
      );
    }
  }
}
