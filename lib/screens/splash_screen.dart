import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_service.dart';
import '../auth/session_service.dart';
import '../theme/app_theme.dart';

const Duration kSplashDisplayDuration = Duration(seconds: 4);

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.displayDuration = kSplashDisplayDuration,
    this.authService,
    this.sessionService,
  });

  final Duration displayDuration;
  final AuthService? authService;
  final SessionService? sessionService;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final AuthService _authService;
  late final SessionService _sessionService;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? FirebaseAuthService();
    _sessionService = widget.sessionService ?? SessionService();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _startSplash();
  }

  Future<void> _startSplash() async {
    // Timer and auth check run concurrently; navigation waits for both.
    final (_, destination) = await (
      Future<void>.delayed(widget.displayDuration),
      _resolveDestination(),
    ).wait;

    if (mounted) context.go(destination);
  }

  Future<String> _resolveDestination() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return '/login';

      final bool valid = await _sessionService.isSessionValid();
      if (!valid) {
        await _authService.signOut();
        return '/login';
      }

      final bool onboarded = await _authService.hasSeenOnboarding();
      return onboarded ? '/map' : '/onboarding';
    } catch (_) {
      return '/login';
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/splash_logo.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 24),
              Text(
                'Nearby',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.ink,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Discover what\'s around you',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.inkSoft,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
