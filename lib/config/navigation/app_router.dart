import 'package:salfah/config/navigation/route_names.dart';
import 'package:salfah/features/game_round/presentation/game_round_binding.dart';
import 'package:salfah/features/settings/presentation/screens/settings_screen.dart';
import 'package:salfah/features/settings/settings_binding.dart';
import 'package:salfah/features/game_round/presentation/screens/game_round_screen.dart';
import 'package:salfah/features/home/presentation/home_binding.dart';
import 'package:salfah/features/home/presentation/screens/home_screen.dart';
import 'package:salfah/features/intro/presentation/screens/intro_screen.dart';
import 'package:salfah/features/players/players_binding.dart';
import 'package:salfah/features/players/presentation/screens/players_screen.dart';
import 'package:salfah/features/round_finish/presentation/round_finish_binding.dart';
import 'package:salfah/features/round_finish/presentation/screens/round_finish_screen.dart';
import 'package:salfah/features/splash/screens/splash_screen.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>> get appRouter {
  return <GetPage<dynamic>>[
    GetPage<dynamic>(name: RouteNames.splash, page: () => const SplashScreen()),
    GetPage<dynamic>(name: RouteNames.intro, page: () => const IntroScreen()),
    GetPage<dynamic>(
      name: RouteNames.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),

    GetPage<dynamic>(
      name: RouteNames.players,
      page: () => const PlayersScreen(),
      binding: PlayersBinding(),
    ),
    GetPage<dynamic>(
      name: RouteNames.gameRound,
      page: () => const GameRoundScreen(),
      binding: GameRoundBinding(),
    ),
    GetPage<dynamic>(
      name: RouteNames.roundFinish,
      page: () => const RoundFinishScreen(),
      binding: RoundFinishBinding(),
    ),
    GetPage<dynamic>(
      name: RouteNames.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
  ];
}
