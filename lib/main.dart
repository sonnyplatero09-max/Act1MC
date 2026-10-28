import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_state_provider.dart';
import 'screens/activities/activity1_screen.dart';
import 'screens/activities/activity2_screen.dart';
import 'screens/activities/activity3_screen.dart';
import 'screens/home_dashboard_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // Global Provider Setup: Injects AppStateProvider at the root of the widget tree
    // so any screen or widget can consume or modify global state.
    ChangeNotifierProvider(
      create: (_) => AppStateProvider(),
      child: const MobileComputingPortfolioApp(),
    ),
  );
}

/// Root Application Widget
///
/// Demonstrates declarative UI:
/// - Listens to [AppStateProvider] for dynamic themeMode and seedColor.
/// - Automatically rebuilds the entire MaterialApp when the theme or profile is changed.
class MobileComputingPortfolioApp extends StatelessWidget {
  const MobileComputingPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch AppStateProvider to react to theme and seed color updates
    final state = context.watch<AppStateProvider>();

    return MaterialApp(
      title: 'Mobile Computing Portfolio Hub',
      debugShowCheckedModeBanner: false,

      // Global Dynamic Theming (Light & Dark)
      themeMode: state.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: state.seedColor,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: state.seedColor,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
      ),

      // Multi-screen Navigation Routes
      initialRoute: HomeDashboardScreen.routeName,
      routes: {
        HomeDashboardScreen.routeName: (context) => const HomeDashboardScreen(),
        Activity1Screen.routeName: (context) => const Activity1Screen(),
        Activity2Screen.routeName: (context) => const Activity2Screen(),
        Activity3Screen.routeName: (context) => const Activity3Screen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
      },
    );
  }
}
