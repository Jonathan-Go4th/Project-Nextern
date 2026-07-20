import 'package:flutter/material.dart';

import 'admin_home_screen.dart';
import 'app_session.dart';
import 'home_screen.dart';

const Color _primaryBlue = Color(0xFF3157F6);
const Color _pageBackground = Color(0xFFF8FAFD);
const Color _fieldBackground = Color(0xFFF5F7FB);
const Color _textPrimary = Color(0xFF202532);
const Color _textSecondary = Color(0xFF788394);
const Color _borderColor = Color(0xFFDDE3ED);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _hidePassword = true;
  bool _checkingSession = true;
  bool _isLoggingIn = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreSession();
    });
  }

  Future<void> _restoreSession() async {
    try {
      final SessionRole? role = await AppSession.getRole();

      if (!mounted) {
        return;
      }

      if (role != null) {
        final Widget destination = role == SessionRole.admin
            ? const AdminHomeScreen()
            : const HomeScreen();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => destination,
          ),
          (Route<dynamic> route) => false,
        );
        return;
      }
    } catch (_) {
      // Continue to the login form if local storage is unavailable.
    }

    if (mounted) {
      setState(() {
        _checkingSession = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFF9AA3B2),
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        size: 19,
        color: const Color(0xFF7C8798),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: _fieldBackground,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: _borderColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: _borderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: _primaryBlue,
          width: 1.4,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.4,
        ),
      ),
    );
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || _isLoggingIn) {
      return;
    }

    setState(() {
      _isLoggingIn = true;
    });

    try {
      await AppSession.signInAs(
        SessionRole.learner,
        email: _emailController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/home',
        (Route<dynamic> route) => false,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoggingIn = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to save the login session. Check shared_preferences setup.',
          ),
        ),
      );
    }
  }

  void _googleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Google authentication will be added later.',
        ),
      ),
    );
  }

  void _forgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Password recovery will be added later.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingSession) {
      return const Scaffold(
        backgroundColor: _pageBackground,
        body: Center(
          child: CircularProgressIndicator(color: _primaryBlue),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 30),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 54,
                ),
                child: Center(
                  child: SizedBox(
                    width: 420,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'NEXTERN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _primaryBlue,
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.7,
                            ),
                          ),
                          const SizedBox(height: 42),
                          const Text(
                            'Welcome back to NEXTERN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 9),
                          const Text(
                            'Enter your credentials to access your dashboard.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 13,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Email field
                          const Text(
                            'Email Address',
                            style: TextStyle(
                              color: Color(0xFF434B59),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 7),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [
                              AutofillHints.email,
                            ],
                            decoration: _inputDecoration(
                              hintText: 'you@university.edu',
                              icon: Icons.email_outlined,
                            ),
                            validator: (String? value) {
                              final String email = value?.trim() ?? '';

                              if (email.isEmpty) {
                                return 'Please enter your email address';
                              }

                              if (!email.contains('@') ||
                                  !email.contains('.')) {
                                return 'Please enter a valid email address';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          // Password heading
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Password',
                                style: TextStyle(
                                  color: Color(0xFF434B59),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: _forgotPassword,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 24),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: _primaryBlue,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _hidePassword,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [
                              AutofillHints.password,
                            ],
                            onFieldSubmitted: (_) {
                              _login();
                            },
                            decoration: _inputDecoration(
                              hintText: 'Enter your password',
                              icon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _hidePassword = !_hidePassword;
                                  });
                                },
                                icon: Icon(
                                  _hidePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 19,
                                  color: const Color(0xFF7C8798),
                                ),
                              ),
                            ),
                            validator: (String? value) {
                              final String password = value ?? '';

                              if (password.isEmpty) {
                                return 'Please enter your password';
                              }

                              if (password.length < 6) {
                                return 'Password must contain at least 6 characters';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Login button
                          ElevatedButton(
                            onPressed: _isLoggingIn ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryBlue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              minimumSize: const Size.fromHeight(49),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: _isLoggingIn
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 22),

                          // Divider
                          const Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: _borderColor,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  'Or continue with',
                                  style: TextStyle(
                                    color: _textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: _borderColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Google button
                          OutlinedButton(
                            onPressed: _googleLogin,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _textPrimary,
                              elevation: 0,
                              minimumSize: const Size.fromHeight(48),
                              side: const BorderSide(
                                color: _borderColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'G',
                                  style: TextStyle(
                                    color: Color(0xFF4285F4),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Google',
                                  style: TextStyle(
                                    color: _textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Learner signup link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'New to Nextern?',
                                style: TextStyle(
                                  color: _textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/signup',
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.only(left: 5),
                                  minimumSize: const Size(0, 30),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    color: _primaryBlue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),

                          // Admin login link
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/admin-login',
                              );
                            },
                            child: const Text(
                              'Login as Admin',
                              style: TextStyle(
                                color: _primaryBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}