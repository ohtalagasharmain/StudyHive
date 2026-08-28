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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? loginError;

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
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: fieldDecoration('Enter your email'),
        ),

        const SizedBox(height: 18),

        fieldLabel('Password'),
        const SizedBox(height: 8),
        TextField(
          controller: passwordController,
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
            onPressed: () {
  final email = emailController.text.trim();
  final password = passwordController.text;

 if (email.isEmpty || password.isEmpty) {
  setState(() {
    loginError = 'Please enter your email and password.';
  });
} else if (email != '1234') {
  setState(() {
    loginError = 'Account doesn’t exist.';
  });
} else if (password != '123456') {
  setState(() {
    loginError = 'Incorrect password.';
  });
} else {
  setState(() {
    loginError = null;
  });

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const HomeScreen(),
    ),
  );
}
},
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
            ), // ElevatedButton
  ),

  const SizedBox(height: 14),

  if (loginError != null)
    Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isLogin = false;
            loginError = null;
          });
        },
        child: Text(
          '$loginError Click Sign Up',
          style: const TextStyle(
            color: Color(0xFFB85A3A),
            fontSize: 14,
            decoration: TextDecoration.underline,
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
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> rooms = [
  {
    'title': 'ROOM 1',
    'members': '4 members',
    'roomCode': '676299',
    'description': 'FOR GROUP A',
    'created': 'Created 2 hours ago',
  },
  {
    'title': 'RESPONDENT’S HIVE',
    'members': '8 members',
    'roomCode': '696832',
    'description': 'FOR GROUP A',
    'created': 'Created August 10, 2026',
  },
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP HEADER
              Row(
                children: [
                  const Text(
                    '🐝 StudyHive',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD96C00),
                    ),
                  ),
                  const Spacer(),

                  IconButton(
                    onPressed: () {showCreateHiveDialog(context);},
                    icon: const Icon(Icons.help_outline),
                  ),

                  const SizedBox(width: 8),

                  ElevatedButton(
                    onPressed: () {showJoinHiveDialog(context);},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF28C00),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Join with Code'),
                  ),

                  const SizedBox(width: 10),

                  const CircleAvatar(
                    radius: 22,
                    child: Icon(Icons.person),
                  ),
                ],
              ),

              const Divider(height: 32),

              const SizedBox(height: 20),

              const Text(
                'Welcome back! 🌻',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                'Here are your study rooms\nand recent activity!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 35),

              Row(
                children: [
                  const Text(
                    'Your Study Rooms',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {showCreateHiveDialog(context);},
                    icon: const Icon(
                      Icons.add,
                      size: 34,
                      color: Color(0xFFF28C00),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

            ...rooms.map(
  (room) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: studyRoomCard(
      title: room['title']!,
      members: room['members']!,
      roomCode: room['roomCode']!,
      description: room['description']!,
      created: room['created']!,
    ),
  ),
),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Send announcement to multiple hives',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Select the hives you created and post one announcement that appears in each room’s chat as a system message.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Announcement',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      decoration: InputDecoration(
                        hintText: 'e.g. Reminder: Tomorrow quiz',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget studyRoomCard({
    required String title,
    required String members,
    required String roomCode,
    required String description,
    required String created,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                members,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            'Created by Student 1',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E8),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFFFD59A),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Room Code: $roomCode',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Copy',
                  style: TextStyle(
                    color: Color(0xFFD96C00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(description),

          const SizedBox(height: 20),

          Row(
            children: [
              Text(
                created,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const Spacer(),

              ElevatedButton(
               onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RoomScreen(
        roomName: title,
        roomCode: roomCode,
      ),
    ),
  );
},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Enter Room'),
              ),

              const SizedBox(width: 12),

              ElevatedButton(
                onPressed: () {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Hive?'),
        content: Text(
          'Are you sure you want to delete "$title"?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                rooms.removeWhere(
                  (room) => room['roomCode'] == roomCode,
                );
              });

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }void showCreateHiveDialog(BuildContext context) {
    final hiveNameController = TextEditingController();
    final descriptionController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text(
          'Create a Hive!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create a room where busy bees can collaborate and learn together! 🍯',
            ),
            const SizedBox(height: 20),
            const Text(
              'Hive name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: hiveNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFDDF5FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFDDF5FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
           onPressed: () {
  final hiveName = hiveNameController.text.trim();
  final description = descriptionController.text.trim();

  if (hiveName.isEmpty) {
    return;
  }

  final roomCode =
      (100000 + DateTime.now().millisecondsSinceEpoch % 900000)
          .toString();

  setState(() {
    rooms.add({
      'title': hiveName.toUpperCase(),
      'members': '1 member',
      'roomCode': roomCode,
      'description':
          description.isEmpty ? 'NO DESCRIPTION' : description.toUpperCase(),
      'created': 'Created just now',
    });
  });

  Navigator.pop(context);
},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF28C00),
              foregroundColor: Colors.white,
            ),
            child: const Text('Create'),
          ),
        ],
      );
    },
  );
}

void showJoinHiveDialog(BuildContext context) {
    final joinCodeController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text(
          'Enter Hive Code!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paste a 6-digit code to enter a hive room.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Join code',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: joinCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFDDF5FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
  final enteredCode = joinCodeController.text.trim();

  final matchingRooms = rooms.where(
    (room) => room['roomCode'] == enteredCode,
  );

  if (matchingRooms.isNotEmpty) {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Successfully joined ${matchingRooms.first['title']}! 🐝',
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hive code not found!'),
      ),
    );
  }
},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF28C00),
              foregroundColor: Colors.white,
            ),
            child: const Text('Join'),
          ),
        ],
      );
    },
  );
}
}class RoomScreen extends StatelessWidget {
  final String roomName;
  final String roomCode;

  const RoomScreen({
    super.key,
    required this.roomName,
    required this.roomCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          roomName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              roomName,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Room Code: $roomCode',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}