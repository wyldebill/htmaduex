import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_service.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.authService});

  final AuthService? authService;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthService _authService;
  bool _signingOut = false;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? FirebaseAuthService();
  }

  Future<void> _signOut() async {
    if (_signingOut) return;
    setState(() => _signingOut = true);
    await _authService.signOut();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.primarySoft,
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 38,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Profile',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Manage your account settings here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.inkSoft),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _signingOut ? null : _signOut,
                icon: const Icon(Icons.logout_rounded),
                label: Text(_signingOut ? 'Signing out...' : 'Log out'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 3,
        onDestinationSelected: (int i) {
          if (i == 0) context.go('/map');
          if (i == 1) context.go('/list');
          if (i == 3) context.go('/profile');
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Map'),
          NavigationDestination(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_rounded),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
