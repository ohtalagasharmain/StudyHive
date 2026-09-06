import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import 'login_page.dart';
import 'student_onboarding_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;
  bool _isLoading = false;
  int _selectedTab = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_agreeTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please agree to the Terms & Conditions'),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      setState(() => _isLoading = true);
      Future.delayed(Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StudentOnboardingPage()),
        );
      });
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
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: 20),
                SizedBox(height: 24),
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
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => LoginPage()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14),
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
                          onTap: () => setState(() => _selectedTab = 1),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14),
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
                  padding: EdgeInsets.all(28),
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
                                'Create Account',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Join StudyHive today',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 28),
                        CustomTextField(
                          label: 'Full Name',
                          controller: _nameController,
                          prefixIcon: Icons.person_outline,
                          hintText: 'Enter Your Fullname',
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          label: 'Email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          hintText: 'Enter Your Email',
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
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
                        CustomTextField(
                          label: 'Confirm Password',
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.honeyDark,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _agreeTerms,
                              onChanged: (v) =>
                                  setState(() => _agreeTerms = v ?? false),
                              activeColor: AppColors.honeyDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: 'I agree to the ',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Terms & Conditions',
                                      style: TextStyle(
                                        color: AppColors.honeyDark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        PrimaryButton(
                          text: 'Create Account',
                          isLoading: _isLoading,
                          onPressed: _handleSignUp,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Log In',
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
