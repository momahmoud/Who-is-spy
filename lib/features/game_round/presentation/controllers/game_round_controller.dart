import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:salfah/config/navigation/route_names.dart';
import 'package:get/get.dart';

/// ------------------------------------------------------------
/// GameRoundController
/// ------------------------------------------------------------
/// Controls the full game round flow:
///
/// 1️⃣ Reveal roles (player / outside player)
/// 2️⃣ Question phase
/// 3️⃣ Voting phase
/// 4️⃣ Final reveal (برا السالفة)
///
/// This controller is UI-agnostic and only manages state.
/// UI listens via `GetBuilder` or `Obx`.
/// ------------------------------------------------------------
class GameRoundController extends GetxController {
  // ================= GAME DATA =================

  /// The secret item of the round
  late final String item;

  /// Category of the item
  late final String category;

  /// Players map (playerName -> votesCount)
  late final Map<String, int> players;

  /// The خارج السالفة player
  late final String outsidePlayer;

  // ================= UI STATE =================

  /// Show finish button after reveal ends
  bool showFinishButton = false;

  /// Current player index
  int counter = 0;

  /// Toggle to show/hide player role card
  bool show = false;

  /// Whether question phase is active
  bool showQuestion = false;

  /// Whether voting phase is active
  bool vote = false;

  /// Whether final reveal screen is shown
  bool showBraSalfa = false;

  /// Whether reveal animation finished
  bool timerFinish = false;

  // ================= GAME LOGIC LISTS =================

  /// Players that still need to be asked
  List<String> askedList = <String>[];

  /// Players that still need to vote
  List<String> voterList = <String>[];

  /// Helper flag to know when questions end
  bool isAskedListEmpty = false;

  // ================= CURRENT STATE VALUES =================

  /// Player being asked
  String asked = '';

  /// Current voter
  String voter = '';

  /// Player who asks the question
  String questioner = '';

  /// Name shown during reveal animation
  String? currentName;

  // ================= AUDIO =================

  final AudioPlayer _player = AudioPlayer();

  // ================= INIT =================

  @override
  void onInit() {
    super.onInit();

    /// Receive navigation arguments
    final Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;

    item = args['item'] as String;
    category = args['category'] as String;
    players = Map<String, int>.from(args['players'] as Map<String, int>);
    outsidePlayer = args['outsidePlayer'] as String;

    /// Shuffle players for randomness
    askedList = players.keys.toList()..shuffle();
    voterList = players.keys.toList()..shuffle();
  }

  // ==========================================================
  // NEXT BUTTON LOGIC
  // ==========================================================
  /// Controls:
  /// - Showing player role
  /// - Moving to next player
  /// - Transition to questions or voting
  void onNextPressed() {
    /// If we are at the last player AND role is shown
    if (counter == players.length - 1 && show) {
      if (!isAskedListEmpty) {
        _startQuestions();
      } else {
        _startVoting();
      }
      update();
      return;
    }

    /// Normal player flow
    if (show) {
      show = false;
      counter++;
    } else {
      show = true;
    }

    update();
  }

  // ==========================================================
  // QUESTION PHASE
  // ==========================================================
  /// Starts the question phase where:
  /// - One player asks
  /// - Another player answers
  void _startQuestions() {
    showQuestion = true;

    isAskedListEmpty = askedList.isEmpty;
    final Random random = Random();

    /// Select asked player
    asked = !isAskedListEmpty
        ? askedList.removeLast()
        : players.keys.elementAt(random.nextInt(players.length));

    /// Select questioner (must be different)
    questioner = players.keys.elementAt(random.nextInt(players.length));

    while (questioner == asked) {
      questioner = players.keys.elementAt(random.nextInt(players.length));
    }
  }

  // ==========================================================
  // VOTING PHASE
  // ==========================================================
  /// Starts voting phase
  void _startVoting() {
    showQuestion = false;
    vote = true;
    showBraSalfa = false;

    if (voterList.isNotEmpty) {
      voter = voterList.removeLast();
    }
  }

  /// Handles a vote from current voter
  void voteForPlayer(String selected) {
    /// Correct guess increases vote count
    if (selected == outsidePlayer) {
      players.update(voter, (int v) => v + 1);
    }

    /// Move to next voter
    if (voterList.isNotEmpty) {
      voter = voterList.removeLast();
    } else {
      /// Voting finished
      vote = false;
      showQuestion = false;
      showBraSalfa = true;

      startRevealPlayers();
    }

    update();
  }

  // ==========================================================
  // FINAL REVEAL
  // ==========================================================
  /// Dramatic reveal animation with sound
  Future<void> startRevealPlayers() async {
    await _player.play(AssetSource('sound/drum_roll.wav'));

    const Duration totalDuration = Duration(milliseconds: 4800);
    const int intervalMs = 300;
    int elapsed = 0;

    Timer.periodic(const Duration(milliseconds: intervalMs), (Timer timer) {
      elapsed += intervalMs;

      /// Random names animation
      if (elapsed < totalDuration.inMilliseconds) {
        currentName = (players.keys.toList()..shuffle()).first;
      } else {
        /// Final reveal
        timer.cancel();
        currentName = outsidePlayer;
        timerFinish = true;
        showFinishButton = true;
      }
      update();
    });
  }

  /// ------------------------------------------------------------
  /// Navigates to the round result screen
  /// ------------------------------------------------------------
  /// Called when:
  /// - Voting is completed
  /// - Final reveal animation finishes
  /// - The round officially ends
  ///
  /// Passes all required game data to the result screen:
  /// - Players with their vote counts
  /// - Outside player name
  /// - Selected category
  /// - Secret item
  ///
  /// Uses `Get.offNamed` to remove the current round
  /// from the navigation stack and prevent going back.
  /// ------------------------------------------------------------
  void goToRoundResult() {
    Get.offNamed<void>(
      RouteNames.roundFinish,
      arguments: <String, dynamic>{
        'players': players,
        'outsidePlayer': outsidePlayer,
        'category': category,
        'item': item,
      },
    );
  }
}
