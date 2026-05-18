import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_service.dart';
import '../theme/app_theme.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, this.authService});

  final AuthService? authService;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late final AuthService _authService;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? FirebaseAuthService();
  }

  Future<void> _resend() async {
    setState(() => _loading = true);
    try {
      await _authService.resendVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Verification email sent.')));
    } on FirebaseAuthException catch (e) {
      final String message = e.code == 'no-user'
          ? 'Your verification session expired. Please go back and sign up again to get a new verification email.'
          : e.code == 'too-many-requests'
          ? 'Too many resend attempts. Please wait a bit before trying again.'
          : (e.message ?? 'Failed to resend.');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to resend.')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify your email')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Icon(
              Icons.mark_email_read_rounded,
              size: 88,
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            const Text(
              'A verification email has been sent to your address. Please click the link in that email to verify your account.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _resend,
              child: Text(
                _loading ? 'Sending...' : 'Resend verification email',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _signOut, child: const Text('Sign out')),
            const Spacer(),
            const Text(
              'Verification links expire after 7 days. If the link expires, you will need to create a new account.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.inkSoft),
            ),
          ],
        ),
      ),
    );
  }
}
