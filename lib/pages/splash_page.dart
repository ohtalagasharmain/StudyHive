import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import 'login_page.dart';
import 'signup_page.dart';

import 'main_shell.dart';
import '../services/app_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );
    
    _controller.forward().then((_) => _checkSession());
  }

  void _checkSession() {
    // If username is not the default, assume logged in
    if (AppState().user.username != 'studyhive') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HoneycombBackground(
      showHoneycomb: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Column(
                            children: [
                              SizedBox(height: 24),
                              Text(
                                'STUDYHIVE',
                                style: Theme.of(context).textTheme.displayLarge
                                    ?.copyWith(
                                      color: AppColors.honeyDark,
                                      letterSpacing: 3,
                                    ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Collaborate. Learn. Master. Together.',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: AppColors.textSecondary),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        PrimaryButton(
                          text: 'Get Started',
                          icon: Icons.arrow_forward,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SignUpPage()),
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        SecondaryButton(
                          text: 'Log In',
                          icon: Icons.login,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => LoginPage()),
                            );
                          },
                        ),
                        SizedBox(height: 32),
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
