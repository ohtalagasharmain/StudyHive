import 'package:flutter/material.dart';

void main() {
  runApp(const StudyHiveApp());
}

class StudyHiveApp extends StatelessWidget {
  const StudyHiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyHive',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;

  InputDecoration fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFDDF5FF),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF6D3B00),
      ),
    );
  }

  Widget loginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            '🐝 Welcome Back to StudyHive!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6D3B00),
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text(
            'Log in to your StudyHive account',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF8B5A2B),
            ),
          ),
        ),
        const SizedBox(height: 28),

        fieldLabel('Email'),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: fieldDecoration('Enter your email'),
        ),

        const SizedBox(height: 18),

        fieldLabel('Password'),
        const SizedBox(height: 8),
        TextField(
          obscureText: true,
          decoration: fieldDecoration('Enter your password'),
        ),

        const SizedBox(height: 12),

        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: Color(0xFF8B5A2B),
              fontSize: 13,
            ),
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF28C00),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Log In',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget signUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            '🐝 Welcome to StudyHive!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6D3B00),
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text(
            'Create your StudyHive account',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF8B5A2B),
            ),
          ),
        ),
        const SizedBox(height: 28),

        fieldLabel('First Name'),
        const SizedBox(height: 8),
        TextField(
          decoration: fieldDecoration('Enter your first name'),
        ),

        const SizedBox(height: 16),

        fieldLabel('Last Name'),
        const SizedBox(height: 8),
        TextField(
          decoration: fieldDecoration('Enter your last name'),
        ),

        const SizedBox(height: 16),

        fieldLabel('Enter your email address'),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: fieldDecoration('Enter your email'),
        ),

        const SizedBox(height: 16),

        fieldLabel('Password'),
        const SizedBox(height: 8),
        TextField(
          obscureText: true,
          decoration: fieldDecoration('Enter your password'),
        ),

        const SizedBox(height: 16),

        fieldLabel('Re-enter your password'),
        const SizedBox(height: 8),
        TextField(
          obscureText: true,
          decoration: fieldDecoration('Confirm your password'),
        ),

        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF28C00),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Sign-up',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF9D9),
              Color(0xFFFFE6A7),
              Color(0xFFFFC46B),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 30,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  const Text(
                    '🐝',
                    style: TextStyle(fontSize: 64),
                  ),

                  const SizedBox(height: 26),

                  Container(
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isLogin = true;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isLogin
                                    ? const Color(0xFFFFC85C)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6D3B00),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isLogin = false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: !isLogin
                                    ? const Color(0xFFFFC85C)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Sign-up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6D3B00),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Container(
                      key: ValueKey(isLogin),
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: isLogin ? loginForm() : signUpForm(),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}