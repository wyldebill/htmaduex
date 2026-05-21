import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';

import 'firebase/app_firebase_options.dart';
import 'screens/detail_screen.dart';
import 'screens/list_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/verification_screen.dart';
import 'screens/map_screen.dart';
import 'screens/wizard_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseOptions firebaseOptions =
      await AppFirebaseOptions.fromPlatform();
  await Firebase.initializeApp(options: firebaseOptions);
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
      path: '/verify',
      builder: (BuildContext context, GoRouterState state) =>
          const VerificationScreen(),
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
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) =>
          const ProfileScreen(),
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
