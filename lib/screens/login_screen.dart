import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_service.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.authService});

  final AuthService? authService;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _signInMode = true;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? FirebaseAuthService();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final String email = _usernameController.text.trim();
    final String password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showMessage('Enter email and password.');
      return;
    }

    try {
      if (_signInMode) {
        await _authService.signIn(email: email, password: password);
      } else {
        await _authService.signUp(email: email, password: password);
      }
      if (!mounted) return;
      context.go('/onboarding');
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? 'Authentication failed.');
    } catch (_) {
      _showMessage('Authentication failed.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(28, 72, 28, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[AppColors.primarySoft, AppColors.bg],
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(top: 0, right: 0, child: _decorativeCircle(18)),
                  Positioned(left: 0, bottom: 8, child: _decorativeCircle(14)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.5,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Nearby',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(
                        _signInMode
                            ? 'Welcome back.'
                            : 'Make the neighborhood yours.',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _signInMode
                            ? 'Sign in to pick up where you left off.'
                            : 'Create a free account to save places and build your list.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  children: <Widget>[
                    _field(
                      label: 'Username',
                      controller: _usernameController,
                      hint: 'you@example.com',
                      obscureText: false,
                    ),
                    _field(
                      label: 'Password',
                      controller: _passwordController,
                      hint: '••••••••',
                      obscureText: true,
                    ),
                    if (_signInMode)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2, bottom: 14),
                          child: Text(
                            'Forgot?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _continue(),
                        child: Text(_signInMode ? 'Sign in' : 'Create account'),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: <Widget>[
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.inkFaint,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _continue(),
                            icon: const Icon(
                              Icons.g_mobiledata_rounded,
                              size: 22,
                            ),
                            label: const Text('Google'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _continue(),
                            icon: const Icon(Icons.apple_rounded),
                            label: const Text('Apple'),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: <Widget>[
                        Text(
                          _signInMode
                              ? "Don't have an account?"
                              : 'Already a member?',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.inkSoft,
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(() => _signInMode = !_signInMode),
                          child: Text(
                            _signInMode ? 'Sign up' : 'Sign in',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.inkSoft,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            obscureText: obscureText,
            onSubmitted: (_) => _continue(),
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }

  Widget _decorativeCircle(double radius) {
    return Column(
      children: <Widget>[
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.35),
          ),
        ),
      ],
    );
  }
}
