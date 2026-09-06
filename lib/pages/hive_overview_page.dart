import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import 'hive_members_page.dart';
import 'chat_page.dart';
import 'quiz_selection_page.dart';
import 'study_materials_page.dart';

class HiveOverviewPage extends StatefulWidget {
  const HiveOverviewPage({super.key});

  @override
  State<HiveOverviewPage> createState() => _HiveOverviewPageState();
}

class _HiveOverviewPageState extends State<HiveOverviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _masteryCompleted = 3;
  final int _masteryTotal = 5;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return HoneycombBackground(
      showGradient: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              if (_tabController.index != 0) _buildHiveInfo(context),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    StudyMaterialsPage(embedded: true),
                    _buildQuizTab(),
                    ChatPage(embedded: true),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationBar(
              selectedIndex: _tabController.index,
              onDestinationSelected: (index) => _tabController.animateTo(index),
              backgroundColor: AppColors.cardWhite,
              indicatorColor: AppColors.honeyYellow.withValues(alpha: 0.45),
              height: 72,
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Overview',
                ),
                NavigationDestination(
                  icon: Icon(Icons.folder_outlined),
                  selectedIcon: Icon(Icons.folder),
                  label: 'Materials',
                ),
                NavigationDestination(
                  icon: Icon(Icons.quiz_outlined),
                  selectedIcon: Icon(Icons.quiz),
                  label: 'Quiz',
                ),
                NavigationDestination(
                  icon: Icon(Icons.chat_bubble_outline),
                  selectedIcon: Icon(Icons.chat_bubble),
                  label: 'Chat',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: AppColors.honeyDark),
          ),
          Spacer(),
          if (_tabController.index == 1 || _tabController.index == 2)
            IconButton(
              onPressed: () {},
              tooltip: 'Focus Session',
              icon: Icon(Icons.timer, color: AppColors.purpleAccent),
            ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none, color: AppColors.honeyDark),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HiveMembersPage()),
              );
            },
            icon: Icon(Icons.group, color: AppColors.honeyDark),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: AppColors.honeyDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHiveInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Color(0xFF42A5F5).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(child: Text('🧪', style: TextStyle(fontSize: 32))),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Physics Hive',
                  style:
                      Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ) ??
                      Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 15,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '5 Members',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.science,
                      size: 15,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Physics',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasteryCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.successGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.successGreen.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Group Mastery',
                style: TextStyle(
                  color: AppColors.successGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                'Great progress! Keep it up! 🎉',
                style: TextStyle(color: AppColors.successGreen, fontSize: 11),
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '72%',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.successGreen,
                ),
              ),
              SizedBox(width: 12),
              Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '+8%',
                    style: TextStyle(
                      color: AppColors.successGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.72,
              minHeight: 10,
              backgroundColor: AppColors.successGreen.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.successGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.flag, color: AppColors.accentOrange),
                  SizedBox(width: 8),
                  Text(
                    "Today's Mission",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$_masteryCompleted/$_masteryTotal',
                  style: TextStyle(
                    color: AppColors.accentOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Text(
            'Answer 10 questions on Newton\'s Second Law',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6),
          Text(
            '3/5 members completed',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _masteryCompleted / _masteryTotal,
              minHeight: 7,
              backgroundColor: AppColors.progressBg,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentOrange),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => QuizSelectionPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successGreen,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: Icon(Icons.rocket_launch, color: Colors.white),
              label: Text(
                'Start Study Session',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHiveInfo(context),
          SizedBox(height: 20),
          _buildMasteryCard(),
          SizedBox(height: 20),
          _buildMissionCard(context),
          SizedBox(height: 4),
          SectionHeader(title: 'Progress'),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildProgressTile(
                  'Quizzes Taken',
                  '12',
                  Icons.quiz,
                  Color(0xFF42A5F5),
                  _buildLineChart(Color(0xFF42A5F5)),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildProgressTile(
                  'Avg. Score',
                  '85%',
                  Icons.star,
                  AppColors.accentOrange,
                  _buildRingProgress(AppColors.accentOrange, 0.85),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildProgressTile(
                  'Study Time',
                  '6.5h',
                  Icons.timer,
                  Color(0xFFEC407A),
                  _buildBarChart(Color(0xFFEC407A)),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildProgressTile(
                  'Missions Completed',
                  '3/5',
                  Icons.flag,
                  AppColors.successGreen,
                  _buildDotProgress(AppColors.successGreen, 3, 5),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          SectionHeader(title: 'Recent Activity'),
          SizedBox(height: 12),
          ...[
            _buildActivityTile(
              'Jai',
              'completed a quiz on Kinematics',
              '2h ago',
              AppColors.successGreen,
              Icons.check_circle,
            ),
            _buildActivityTile(
              'Derick',
              'uploaded Notes_Formula.pdf',
              '5h ago',
              Color(0xFF42A5F5),
              Icons.upload_file,
            ),
            _buildActivityTile(
              'Kirsten',
              'joined the Physics Hive',
              '1d ago',
              AppColors.purpleAccent,
              Icons.person_add,
            ),
          ],
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildProgressTile(
    String title,
    String value,
    IconData icon,
    Color color,
    Widget miniGraphic,
  ) {
    return Container(
      height: 142,
      padding: EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          SizedBox(height: 24, child: miniGraphic),
        ],
      ),
    );
  }

  Widget _buildLineChart(Color color) {
    return CustomPaint(painter: _MiniLineChartPainter(color));
  }

  Widget _buildRingProgress(Color color, double progress) {
    return CustomPaint(painter: _MiniRingPainter(color, progress));
  }

  Widget _buildBarChart(Color color) {
    return CustomPaint(painter: _MiniBarChartPainter(color));
  }

  Widget _buildDotProgress(Color color, int completed, int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        total,
        (index) => Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: index < completed ? color : color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildActivityTile(
    String name,
    String action,
    String time,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(child: Icon(icon, color: color, size: 18)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' $action'),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    time,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Hive Quizzes'),
          SizedBox(height: 12),
          ...[
            _buildQuizCard(
              'Newton\'s Laws of Motion',
              '15 questions',
              'Medium',
              82,
            ),
            _buildQuizCard('Kinematics Basics', '20 questions', 'Easy', 90),
            _buildQuizCard('Work, Energy, Power', '25 questions', 'Hard', 64),
          ],
          SizedBox(height: 16),
          PrimaryButton(
            text: 'Create Hive Quiz',
            icon: Icons.add,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => QuizSelectionPage()),
              );
            },
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildQuizCard(
    String title,
    String qCount,
    String difficulty,
    int mastery,
  ) {
    Color diffColor = difficulty == 'Easy'
        ? AppColors.successGreen
        : difficulty == 'Medium'
        ? AppColors.accentOrange
        : AppColors.errorRed;
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.purpleAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.quiz, color: AppColors.purpleAccent, size: 26),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.help_outline,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        qCount,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 16),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: diffColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          difficulty,
                          style: TextStyle(
                            color: diffColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$mastery%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.successGreen,
                  ),
                ),
                SizedBox(height: 6),
                Icon(
                  Icons.play_circle,
                  color: AppColors.purpleAccent,
                  size: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniLineChartPainter extends CustomPainter {
  final Color color;

  _MiniLineChartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(0, size.height * 0.75)
      ..lineTo(size.width * 0.25, size.height * 0.55)
      ..lineTo(size.width * 0.48, size.height * 0.65)
      ..lineTo(size.width * 0.72, size.height * 0.25)
      ..lineTo(size.width, size.height * 0.4);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MiniLineChartPainter oldDelegate) =>
      color != oldDelegate.color;
}

class _MiniRingPainter extends CustomPainter {
  final Color color;
  final double progress;

  _MiniRingPainter(this.color, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.height / 2 - 3;
    final backgroundPaint = Paint()
      ..color = color.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MiniRingPainter oldDelegate) =>
      color != oldDelegate.color || progress != oldDelegate.progress;
}

class _MiniBarChartPainter extends CustomPainter {
  final Color color;

  _MiniBarChartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const values = [0.45, 0.75, 0.58, 0.95, 0.68];
    final barWidth = size.width / 9;
    for (var index = 0; index < values.length; index++) {
      final barHeight = size.height * values[index];
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            index * barWidth * 1.8,
            size.height - barHeight,
            barWidth,
            barHeight,
          ),
          Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MiniBarChartPainter oldDelegate) =>
      color != oldDelegate.color;
}
