import 'package:flutter/material.dart';

import '../services/subscription_router.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import 'signup_page.dart';
import '../services/app_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  int _selectedTab = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() => _isLoading = false);
        SubscriptionRouter.navigateBasedOnSubscription(context);
      });

      // Mock login persistence
        final email = _emailController.text.trim();
        final username = email.split('@').first;
        
        AppState().updateUser(UserData(
          name: username.toUpperCase(),
          username: username,
          subjects: 'General Study',
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return HoneycombBackground(
      showHoneycomb: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(14),
            child: Column(
              children: [
                SizedBox(height: 20),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.honeyYellow, width: 2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTab = 0),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: _selectedTab == 0
                                  ? AppColors.honeyYellow.withValues(alpha: 0.5)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(18),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedTab == 0
                                      ? AppColors.honeyDark
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => SignUpPage()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: _selectedTab == 1
                                  ? AppColors.honeyYellow.withValues(alpha: 0.5)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(18),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Sign-up',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedTab == 1
                                      ? AppColors.honeyDark
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                    border: Border.all(color: AppColors.honeyYellow, width: 2),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                '🍯 Welcome Back to StudyHive!',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Log in to your StudyHive account',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          label: 'Email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value!)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          label: 'Password',
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.honeyDark,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your password';
                            }
                            if (value!.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                final resetEmailController = TextEditingController(text: _emailController.text);
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: const Text('Reset Password'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('Enter your registered email address to receive password reset instructions.'),
                                        const SizedBox(height: 12),
                                        TextField(
                                          controller: resetEmailController,
                                          decoration: const InputDecoration(labelText: 'Email Address'),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(dialogContext),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Password reset link sent to ${resetEmailController.text.isEmpty ? "your email" : resetEmailController.text}!')),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.honeyDark),
                                        child: const Text('Send Reset Link'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text('Forgot Password?'),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        PrimaryButton(
                          text: 'Log in',
                          isLoading: _isLoading,
                          onPressed: _handleLogin,
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppColors.honeyCombLine,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'or continue with',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColors.honeyCombLine,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        SecondaryButton(
                          text: 'Continue with Google',
                          icon: Icons.g_mobiledata,
                          onPressed: _handleLogin,
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SignUpPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: AppColors.honeyDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
