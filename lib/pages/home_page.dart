import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import 'hives_page.dart';
import 'join_hive_page.dart';
import 'hive_overview_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DateTime _examDate = DateTime(2026, 6, 15);

  int get _daysUntilExam {
    final now = DateTime.now();
    final diff = _examDate
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    return diff > 0 ? diff : 0;
  }

  @override
  Widget build(BuildContext context) {
    return HoneycombBackground(
      showGradient: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
            SizedBox(height: 24),
            _buildGreeting(context),
            SizedBox(height: 24),
            _buildExamCountdown(context),
            SizedBox(height: 20),
            SectionHeader(
              title: "Today's Study Plan",
              trailing: TextButton(onPressed: () {}, child: Text('See All')),
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
                    '8',
                    Icons.local_fire_department,
                    AppColors.accentOrange,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Daily Progress',
                    '65%',
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
                  MaterialPageRoute(builder: (_) => HivesPage()),
                );
              },
              actionText: 'See All',
              trailing: Container(
                decoration: BoxDecoration(
                  color: AppColors.honeyDark,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.honeyDark.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add, color: Colors.white, size: 20),
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(),
                ),
              ),
            ),
            SizedBox(height: 12),
            _buildHivesPreview(context),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'StudyHive',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.honeyDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Spacer(),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.honeyYellow.withValues(alpha: 0.5),
            ),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Stack(
              children: [
                Icon(Icons.help_outline, color: AppColors.honeyDark, size: 24),
              ],
            ),
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => JoinHivePage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.honeyDark,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: Icon(Icons.qr_code_scanner, color: Colors.white, size: 18),
          label: Text(
            'Join with Code',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting(BuildContext context) {
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
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Welcome back! ',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              TextSpan(text: '🌻', style: TextStyle(fontSize: 28)),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          '$greeting Studyhive! Here are your study rooms and recent activity!',
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
        boxShadow: [
          BoxShadow(
            color: AppColors.honeyDark.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
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
                  'Physics Midterms',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '$_daysUntilExam days left',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '6 Days Left',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.honeyDark,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'View Details',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
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
      {
        'title': 'Group Study Session',
        'time': '45 min',
        'subject': 'Physics Hive',
        'progress': 0.0,
        'icon': Icons.group,
        'color': AppColors.successGreen,
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
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${item['time']} • ${item['subject']}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: item['progress'] as double,
                        minHeight: 5,
                        backgroundColor: AppColors.progressBg,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          item['color'] as Color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.play_circle,
                  color: item['color'] as Color,
                  size: 32,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContinueStudyingCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HiveOverviewPage()),
        );
      },
      child: Container(
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Spacer(),
              if (label == 'Daily Progress')
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '+5%',
                    style: TextStyle(
                      color: AppColors.successGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
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
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 0.65,
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

  Widget _buildHivesPreview(BuildContext context) {
    return Column(
      children: [
        HiveCard(
          name: 'ROOM 1',
          subject: 'FOR GROUP A',
          memberCount: 4,
          mastery: 75,
          code: '676299',
          createdBy: 'Student 1',
          createdAt: '2 hours ago',
          onEnter: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HiveOverviewPage()),
            );
          },
          onDelete: () {},
        ),
        SizedBox(height: 16),
        HiveCard(
          name: "RESPONDENT'S HIVE",
          subject: 'FOR GROUP A',
          memberCount: 8,
          mastery: 68,
          code: '696832',
          createdBy: 'Student 1',
          createdAt: 'August 10, 2026',
          onEnter: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HiveOverviewPage()),
            );
          },
          onDelete: () {},
        ),
        SizedBox(height: 16),
        _buildAnnouncementCard(context),
      ],
    );
  }

  Widget _buildAnnouncementCard(BuildContext context) {
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
            'Send announcement to multiple hives',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text(
            'Select the hives you created and post one announcement that appears in each room\'s chat as a system message.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          SizedBox(height: 16),
          Text(
            'Announcement',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontSize: 14),
          ),
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'e.g. Reminder: Tomorrow quiz',
              filled: true,
              fillColor: AppColors.cardWhite,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.honeyCombLine),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
