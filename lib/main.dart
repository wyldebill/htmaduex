import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/detail_screen.dart';
import 'screens/list_screen.dart';
import 'screens/login_screen.dart';
import 'screens/map_screen.dart';
import 'screens/wizard_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const NearbyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const LoginScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) =>
          const WizardScreen(),
    ),
    GoRoute(
      path: '/wizard',
      redirect: (BuildContext context, GoRouterState state) => '/onboarding',
    ),
    GoRoute(
      path: '/map',
      builder: (BuildContext context, GoRouterState state) => const MapScreen(),
    ),
    GoRoute(
      path: '/list',
      builder: (BuildContext context, GoRouterState state) =>
          const ListScreen(),
    ),
    GoRoute(
      path: '/business/:id',
      builder: (BuildContext context, GoRouterState state) {
        final int id = int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
        return DetailScreen(businessId: id);
      },
    ),
  ],
);

class NearbyApp extends StatelessWidget {
  const NearbyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nearby',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routerConfig: _router,
    );
  }
}
