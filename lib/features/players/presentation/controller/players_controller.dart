import 'dart:async';
import 'dart:math';

import 'package:salfah/config/navigation/route_names.dart';
import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/const/const_strings.dart' show AppStrings;
import 'package:salfah/core/helpers/app_helper_functions.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/core/utilities/app_logger.dart';
import 'package:salfah/features/ads/presentation/controller/coins_controller.dart';
import 'package:salfah/features/ads/services/ads_service.dart';
import 'package:salfah/features/monetization/services/monetization_bonus_service.dart';
import 'package:salfah/features/players/presentation/dialogs/add_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayersController extends GetxController {
  PlayersController();

  final String selectedCategory = Get.arguments as String;
  bool isLoading = true;
  bool isStartingGame = false;

  final Map<int, String> players = <int, String>{
    1: Get.context!.localization.player1,
    2: Get.context!.localization.player2,
    3: Get.context!.localization.player3,
  }.obs;

  final TextEditingController nameController = TextEditingController();

  bool isAdd = false;
  bool isEdit = false;
  int editingKey = 0;

  final Random _random = Random();
  final CoinsController coinsController = Get.find<CoinsController>();
  final AdsService _adsService = Get.find<AdsService>();

  @override
  void onInit() {
    super.onInit();
    AppLogger().info('Selected Category is $selectedCategory');
    _adsService.preloadInterstitial();
    _init();
  }

  Future<void> _init() async {
    await AppHelperFunctions().load(
      Get.locale ?? const Locale(AppStrings.arabicLang),
    );
    isLoading = false;
    update();
  }

  String getRandomItem() {
    return AppHelperFunctions().getRandomItem(selectedCategory);
  }

  void showAddDialog() {
    isAdd = true;
    Get.dialog<void>(
      GetBuilder<PlayersController>(builder: (_) => const AddEditDialog()),
    );

    update();
  }

  void showEditDialog(int key, String name) {
    isEdit = true;
    editingKey = key;

    nameController.text = name;

    Get.dialog<void>(
      GetBuilder<PlayersController>(builder: (_) => const AddEditDialog()),
    );
  }

  void closeDialog() {
    isAdd = false;
    isEdit = false;
    nameController.clear();
    Get.back<void>();
    update();
  }

  void addOrEditPlayer() {
    if (nameController.text.isEmpty) return;

    if (isAdd) {
      players[players.length + 1] = nameController.text;
    } else if (isEdit) {
      players[editingKey] = nameController.text;
    }

    closeDialog();
  }

  void removePlayer(int key) {
    players.remove(key);
    update();
  }

  String getRandomPlayer() {
    return players.values.elementAt(_random.nextInt(players.length));
  }

  Future<void> startGame() async {
    if (isStartingGame) return;

    if (players.length < 3) {
      Get.snackbar(
        Get.context!.localization.error,
        Get.context!.localization.minPlayersMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.color3,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    isStartingGame = true;
    update();

    try {
      unawaited(
        MonetizationBonusService.maybeAwardLobbyPlayerCountBonus(
          seatedPlayerCount: players.length,
        ),
      );

      await _adsService.showInterstitial(policyCooldownOnly: true);

      final String item = getRandomItem();
      final String outsidePlayer = getRandomPlayer();

      final Map<String, int> playersWithScore = <String, int>{
        for (final MapEntry<int, String> entry in players.entries)
          entry.value: 0,
      };

      AppLogger().info('Item: $item');
      AppLogger().info('Outside Player: $outsidePlayer');
      AppLogger().info('Players: $playersWithScore');

      await Get.toNamed<void>(
        RouteNames.gameRound,
        arguments: <String, Object>{
          'item': item,
          'category': selectedCategory,
          'players': playersWithScore,
          'outsidePlayer': outsidePlayer,
        },
      );
    } finally {
      isStartingGame = false;
      update();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
