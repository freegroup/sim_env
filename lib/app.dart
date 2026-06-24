import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/world_view/world_screen.dart';
import 'features/navigation/navigation_screen.dart';
import 'features/investment/investment_screen.dart';

final _routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/world',
    routes: [
      GoRoute(path: '/world', builder: (_, __) => const WorldScreen()),
      GoRoute(path: '/navigate', builder: (_, __) => const NavigationScreen()),
      GoRoute(path: '/invest', builder: (_, __) => const InvestmentScreen()),
    ],
  );
});

class SimEnvApp extends ConsumerWidget {
  const SimEnvApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(_routerProvider);
    return MaterialApp.router(
      title: 'SimEnv',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        // Large fonts for accessibility
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 20),
          bodyMedium: TextStyle(fontSize: 18),
          titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      routerConfig: router,
    );
  }
}
