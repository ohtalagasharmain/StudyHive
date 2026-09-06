import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/reusable_widgets.dart';
import 'home_page.dart';
import 'hives_page.dart';
import 'quiz_selection_page.dart';
import 'profile_page.dart';
import 'create_hive_page.dart';
import 'join_hive_page.dart';
import 'study_materials_page.dart';
import 'hive_overview_page.dart';
import 'hive_chat_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    HivesPage(),
    HiveChatPage(),
    ProfilePage(),
  ];

  void _onNavTap(int index) {
    if (index == 4) {
      _showQuickActionMenu();
    } else {
      setState(() => _currentIndex = index);
    }
  }

  void _showQuickActionMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.honeyCombLine,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 28),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildActionItem(
                  context,
                  icon: Icons.hive,
                  label: 'Create Hive',
                  color: AppColors.honeyDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CreateHivePage()),
                    );
                  },
                ),
                _buildActionItem(
                  context,
                  icon: Icons.group_add,
                  label: 'Join Hive',
                  color: AppColors.purpleAccent,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => JoinHivePage()),
                    );
                  },
                ),
                _buildActionItem(
                  context,
                  icon: Icons.upload_file,
                  label: 'Upload Material',
                  color: AppColors.successGreen,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => StudyMaterialsPage()),
                    );
                  },
                ),
                _buildActionItem(
                  context,
                  icon: Icons.timer,
                  label: 'Start Study Session',
                  color: AppColors.accentOrange,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HiveOverviewPage()),
                    );
                  },
                ),
                _buildActionItem(
                  context,
                  icon: Icons.quiz,
                  label: 'Create Quiz',
                  color: Color(0xFF42A5F5),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => QuizSelectionPage()),
                    );
                  },
                ),
                _buildActionItem(
                  context,
                  icon: Icons.auto_awesome,
                  label: 'Generate Content',
                  color: Color(0xFFEC407A),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => StudyMaterialsPage()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: BottomNav(currentIndex: _currentIndex, onTap: _onNavTap),
      ),
    );
  }
}
