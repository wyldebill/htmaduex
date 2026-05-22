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
  bool _isSubmitting = false;
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
    if (_isSubmitting) return;

    final String email = _usernameController.text.trim();
    final String password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showMessage('Enter email and password.');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      if (_signInMode) {
        await _authService.signIn(email: email, password: password);
        if (!mounted) return;
        final bool hasSeenOnboarding = await _authService.hasSeenOnboarding();
        if (!mounted) return;
        context.go(hasSeenOnboarding ? '/map' : '/onboarding');
      } else {
        await _authService.signUp(email: email, password: password);
        if (!mounted) return;
        // After signup we send verification and route to verification flow
        context.go('/verify');
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific verification related errors
      if (e.code == 'email-not-verified') {
        if (!mounted) return;
        // Route to verification UI
        context.go('/verify');
        return;
      }
      if (e.code == 'email-not-verified-expired') {
        _showMessage(
          e.message ??
              'Verification window expired. Please create a new account.',
        );
        return;
      }

      _showMessage(_friendlyAuthMessage(e));
    } catch (_) {
      _showMessage('Authentication failed.');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _friendlyAuthMessage(FirebaseAuthException exception) {
    if (exception.code == 'too-many-requests') {
      return 'Too many attempts from this device. Please wait a bit and try again.';
    }
    return exception.message ?? 'Authentication failed.';
  }

  void _showMessage(String message) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  void _showNotImplementedMessage(String feature) {
    _showMessage('$feature is not implemented yet.');
  }

  Future<void> _showForgotPasswordSheet() async {
    if (_isSubmitting) return;

    final TextEditingController sheetController =
        TextEditingController(text: _usernameController.text);

    // We'll create a listener that triggers the StatefulBuilder's setState
    // so the Send button updates as the user types. Keep a reference so we
    // can remove it when the sheet is dismissed.
    StateSetter? sheetSetState;
    void listener() {
      if (sheetSetState != null) sheetSetState!(() {});
    }

    sheetController.addListener(listener);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).canvasColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (BuildContext ctx) {
        bool sheetSubmitting = false;
        return StatefulBuilder(builder: (BuildContext context, setState) {
          // Expose the setState to our listener so typing can trigger rebuilds.
          sheetSetState = setState;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                top: false,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox(width: 48),
                          const Text(
                            'Reset password',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            key: const ValueKey('forgot-cancel-button'),
                            onPressed: sheetSubmitting
                                ? null
                                : () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Enter your account email to receive reset instructions',
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        key: const ValueKey('forgot-email-field'),
                        controller: sheetController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'you@example.com',
                        ),
                        onSubmitted: (_) async {
                          if (sheetSubmitting) return;
                          await _handleSendReset(
                            sheetController,
                            (bool v) => setState(() => sheetSubmitting = v),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          key: const ValueKey('forgot-send-button'),
                          onPressed: (sheetController.text.trim().isEmpty || sheetSubmitting)
                              ? null
                              : () async {
                                  await _handleSendReset(
                                    sheetController,
                                    (bool v) => setState(() => sheetSubmitting = v),
                                  );
                                },
                          child: sheetSubmitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Send reset'),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );

    // Cleanup listener after the sheet is dismissed. Avoid disposing the
    // controller here to prevent race conditions with the framework as the
    // sheet unmounts in tests and during animations.
    sheetController.removeListener(listener);
    sheetSetState = null;
  }

  Future<void> _handleSendReset(
    TextEditingController sheetController,
    void Function(bool) setSubmitting,
  ) async {
    final String email = sheetController.text.trim();
    if (email.isEmpty) return;

    setSubmitting(true);
    try {
      await _authService.sendPasswordResetEmail(email);
      if (!mounted) return;
      Navigator.of(context).pop();
      _showMessage('Password reset email sent.');
    } on FirebaseAuthException catch (e) {
      _showMessage(_friendlyAuthMessage(e));
    } catch (_) {
      _showMessage('Password reset failed.');
    } finally {
      setSubmitting(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(28, 56, 28, 20),
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
                            'HTMAr',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        _signInMode
                            ? 'Welcome back.'
                            : 'Make the neighborhood yours.',
                        style: Theme.of(context).textTheme.displayLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _signInMode
                            ? 'Sign in to pick up where you left off.'
                            : 'Create a free account to save places and build your list.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.inkSoft,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 20,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                                padding: const EdgeInsets.only(
                                  top: 2,
                                  bottom: 14,
                                ),
                                child: TextButton(
                                  onPressed: _isSubmitting
                                      ? null
                                      : _showForgotPasswordSheet,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Forgot?',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSubmitting
                                  ? null
                                  : () => _continue(),
                              child: _isSubmitting
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          _signInMode
                                              ? 'Signing in...'
                                              : 'Creating...',
                                        ),
                                      ],
                                    )
                                  : Text(
                                      _signInMode
                                          ? 'Sign in'
                                          : 'Create account',
                                    ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            children: <Widget>[
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
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
                                  onPressed: _isSubmitting
                                      ? null
                                      : () => _showNotImplementedMessage(
                                        _signInMode
                                            ? 'Google sign in'
                                            : 'Google sign up',
                                      ),
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
                                  onPressed: _isSubmitting
                                      ? null
                                      : () => _showNotImplementedMessage(
                                        _signInMode
                                            ? 'Apple sign in'
                                            : 'Apple sign up',
                                      ),
                                  icon: const Icon(Icons.apple_rounded),
                                  label: const Text('Apple'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
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
                                onPressed: _isSubmitting
                                    ? null
                                    : () {
                                        setState(() {
                                          _signInMode = !_signInMode;
                                          // Clear fields when toggling modes to match
                                          // expected UX and widget tests.
                                          _usernameController.clear();
                                          _passwordController.clear();
                                        });
                                        // Ensure no field remains focused.
                                        FocusScope.of(context).unfocus();
                                      },
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
                  );
                },
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
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
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
