import 'package:flutter/material.dart';
import 'dart:io';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import 'hives_page.dart';
import 'hive_overview_page.dart';
import 'create_hive_page.dart';
import 'study_plan_page.dart';
import '../services/app_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DateTime _examDate = DateTime(2026, 6, 15);
  final _announcementController = TextEditingController();
  final _selectedAnnouncementHives = <String>{};

  @override
  void dispose() {
    _announcementController.dispose();
    super.dispose();
  }

  int get _daysUntilExam {
    final now = DateTime.now();
    final diff = _examDate
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    return diff > 0 ? diff : 0;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final user = AppState().user;
        final hives = AppState().hives.where((h) => 
          h.membersList.contains(user.name) || 
          h.membersList.contains('You') || 
          h.owned).toList();

        return HoneycombBackground(
          showGradient: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context, user),
                SizedBox(height: 24),
                _buildGreeting(context, user),
                SizedBox(height: 24),
                _buildExamCountdown(context),
                SizedBox(height: 20),
                SectionHeader(
                  title: "Today's Study Plan",
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StudyPlanPage()),
                      );
                    },
                    child: const Text('See All'),
                  ),
                ),
                SizedBox(height: 12),
                _buildStudyPlanItems(context),
                SizedBox(height: 24),
                _buildContinueStudyingCard(context),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Study Streak',
                        '${AppState().studyStreak}',
                        Icons.local_fire_department,
                        AppColors.accentOrange,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Daily Progress',
                        '${(AppState().dailyProgress * 100).toInt()}%',
                        Icons.trending_up,
                        AppColors.successGreen,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 28),
                SectionHeader(
                  title: 'My Hives',
                  onSeeAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HivesPage()),
                    );
                  },
                  actionText: 'See All',
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: AppColors.honeyDark,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CreateHivePage()),
                      ),
                      icon: Icon(Icons.add, color: Colors.white, size: 20),
                      padding: EdgeInsets.all(4),
                      constraints: BoxConstraints(),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                if (hives.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text('No hives yet. Create or join one!', 
                        style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  )
                else
                  ...hives.take(2).map((h) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: HiveCard(
                      name: h.name,
                      subject: h.subject,
                      memberCount: h.members,
                      mastery: h.mastery,
                      onEnter: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HiveOverviewPage(
                              hiveId: h.id,
                              hiveName: h.name,
                              hiveSubject: h.subject,
                              hiveIcon: h.icon,
                            ),
                          ),
                        );
                      },
                    ),
                  )),
                SizedBox(height: 16),
                _buildAnnouncementCard(context, hives),
                SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, UserData user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'StudyHive',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.honeyDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Welcome,',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
                ),
                Text(
                  user.name,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.honeyYellow.withValues(alpha: 0.3),
              backgroundImage: user.profilePicturePath != null 
                  ? FileImage(File(user.profilePicturePath!)) 
                  : null,
              child: user.profilePicturePath == null 
                  ? const Icon(Icons.person, color: AppColors.honeyDark, size: 20)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGreeting(BuildContext context, UserData user) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning,'
        : hour < 17
        ? 'Good afternoon,'
        : hour < 21
        ? 'Good evening,'
        : 'Good night,';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back! 🐝',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        SizedBox(height: 8),
        Text(
          '$greeting ${user.name}! Ready to master your subjects?',
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(color: AppColors.textSecondary, fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildExamCountdown(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.honeyDark, AppColors.accentOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.event_note, color: Colors.white, size: 32),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Final Exams',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '$_daysUntilExam days left',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyPlanItems(BuildContext context) {
    final items = [
      {
        'title': 'Review Newton\'s Laws',
        'time': '30 min',
        'subject': 'Physics',
        'progress': 0.8,
        'icon': Icons.menu_book,
        'color': AppColors.honeyDark,
      },
      {
        'title': 'Practice Quiz',
        'time': '20 min',
        'subject': 'Math',
        'progress': 0.3,
        'icon': Icons.quiz,
        'color': AppColors.purpleAccent,
      },
    ];
    return Column(
      children: items.map((item) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (item['color'] as Color).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: item['color'] as Color,
                  size: 24,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${item['time']} • ${item['subject']}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContinueStudyingCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.purpleAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.purpleAccent.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.purpleAccent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.play_arrow, color: Colors.white, size: 28),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Continue Studying',
                  style: TextStyle(
                    color: AppColors.purpleAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Mastery: 72% Newton\'s Second Law',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: AppColors.purpleAccent),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      height: 142,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (label == 'Daily Progress') ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: AppState().dailyProgress,
                minHeight: 6,
                backgroundColor: AppColors.progressBg,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(BuildContext context, List<HiveData> hives) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send announcement',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _announcementController,
            decoration: InputDecoration(
              hintText: 'e.g. Reminder: Tomorrow quiz',
              filled: true,
              fillColor: AppColors.creamLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 14),
          Text(
            'Select Hives',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
          ...hives.map(
            (hive) => CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(hive.name),
              value: _selectedAnnouncementHives.contains(hive.name),
              onChanged: (value) => setState(() {
                if (value == true) {
                  _selectedAnnouncementHives.add(hive.name);
                } else {
                  _selectedAnnouncementHives.remove(hive.name);
                }
              }),
            ),
          ),
          SizedBox(height: 16),
          PrimaryButton(
            text: 'Send Announcement',
            onPressed: () {
              if (_announcementController.text.trim().isEmpty || _selectedAnnouncementHives.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add an announcement and select at least one Hive.')),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Announcement sent to ${_selectedAnnouncementHives.length} Hive(s).')),
              );
              _announcementController.clear();
              setState(() => _selectedAnnouncementHives.clear());
            },
          ),
        ],
      ),
    );
  }
}
