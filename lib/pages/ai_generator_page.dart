import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import 'flashcards_page.dart';
import 'ai_summary_page.dart';

class AIGeneratorPage extends StatefulWidget {
  const AIGeneratorPage({super.key});

  @override
  State<AIGeneratorPage> createState() => _AIGeneratorPageState();
}

class _AIGeneratorPageState extends State<AIGeneratorPage> {
  bool _isGenerating = true;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) setState(() => _isGenerating = false);
    });
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
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: AppColors.honeyDark),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI Study Generator',
                        style: Theme.of(context).textTheme.headlineMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isGenerating
                    ? _buildLoadingState()
                    : _buildGeneratedContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(height: 60),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(seconds: 1),
            builder: (context, value, child) {
              return Transform.rotate(angle: value * 6.28319, child: child);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.honeyYellow.withValues(alpha: 0.2),
                  ),
                ),
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.honeyYellow.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 36),
          Text(
            'Generating content...',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 12),
          Text(
            'Hang tight! Our AI is creating high-quality study material for you.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          SizedBox(
            width: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                minHeight: 8,
                backgroundColor: AppColors.progressBg,
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color.fromRGBO(220, 115, 0, 1),
                ),
              ),
            ),
          ),
          SizedBox(height: 28),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildLoadingChip('📄 Summary'),
              _buildLoadingChip('🎴 Flashcards'),
              _buildLoadingChip('❓ Practice Questions'),
              _buildLoadingChip('🔑 Key Concepts'),
              _buildLoadingChip('🎯 Weak Topics'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.honeyYellow),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.honeyDark),
            ),
          ),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratedContent() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(16),
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
                _buildContentTab(0, '📄 Summary'),
                _buildContentTab(1, '🎴 Flashcards'),
                _buildContentTab(2, '❓ Questions'),
                _buildContentTab(3, '🔑 Concepts'),
              ],
            ),
          ),
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                255,
                220,
                115,
                0,
              ).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color.fromARGB(
                  255,
                  220,
                  115,
                  0,
                ).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: const Color.fromARGB(255, 248, 19, 19),
                  size: 18,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Newton's Laws of Motion - Study Pack ready!",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 248, 19, 19),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: _buildTabContent()),
      ],
    );
  }

  Widget _buildContentTab(int index, String label) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.honeyYellow.withValues(alpha: 0.4)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: isSelected
                      ? AppColors.honeyDark
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildSummaryTab();
      case 1:
        return _buildFlashcardsTab();
      case 2:
        return _buildQuestionsTab();
      case 3:
        return _buildConceptsTab();
      default:
        return Container();
    }
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Summary'),
          SizedBox(height: 12),
          Container(
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
                Text(
                  "Newton's Laws of Motion explain the relationship between the motion of an object and the forces acting on it. These three laws form the foundation of classical mechanics.",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    height: 1.6,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "First Law (Inertia): An object at rest stays at rest, and an object in motion stays in motion with constant speed unless acted upon by a net force.",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    height: 1.6,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Second Law (F=ma): The acceleration of an object is directly proportional to the net force and inversely proportional to its mass.",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    height: 1.6,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Third Law (Action-Reaction): For every action, there is an equal and opposite reaction.",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    height: 1.6,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          _buildSectionTitle('Key Points'),
          SizedBox(height: 12),
          ...[
            'Inertia depends on mass — heavier objects resist change more',
            'Force and acceleration always act in the same direction',
            'Action and reaction forces act on DIFFERENT objects, not the same one',
          ].map((p) => _buildBulletPoint(p)),
          SizedBox(height: 16),
          _buildSectionTitle('Important Terms'),
          SizedBox(height: 12),
          ...[
            {
              'term': 'Inertia',
              'def': 'The tendency of an object to resist changes in motion',
            },
            {
              'term': 'Net Force',
              'def': 'The vector sum of all forces acting on an object',
            },
            {
              'term': 'Mass',
              'def': 'Measure of the amount of matter in an object (in kg)',
            },
          ].map(
            (t) => Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.honeyYellow.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.honeyDark.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.lightbulb,
                        color: AppColors.honeyDark,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t['term']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.honeyDark,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            t['def']!,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Simplify',
                  icon: Icons.compress,
                  fullWidth: true,
                  onPressed: () {},
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: PrimaryButton(
                  text: 'Explain More',
                  icon: Icons.unfold_more,
                  fullWidth: true,
                  backgroundColor: AppColors.purpleAccent,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AISummaryPage()),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: 'Quiz Me',
                  icon: Icons.quiz,
                  fullWidth: true,
                  backgroundColor: AppColors.successGreen,
                  onPressed: () {},
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SecondaryButton(
                  text: 'Save',
                  icon: Icons.bookmark,
                  fullWidth: true,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          TextButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, color: AppColors.honeyDark, size: 18),
                SizedBox(width: 8),
                Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.honeyDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFlashcardsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSectionTitle('12 Flashcards Ready'),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FlashcardsPage()),
              );
            },
            child: _buildFlipCard(
              question: "Q1\nWhat is Newton's First Law of Motion?",
              answer: "The Law of Inertia:\nAn object at rest stays at rest, and an object in motion stays in motion unless acted upon by a net force.",
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: i == 0 ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == 0 ? AppColors.honeyDark : AppColors.honeyYellow,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successGreen,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: Icon(Icons.check, size: 18),
                  label: Text(
                    'I Know It',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorRed,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: Icon(Icons.refresh, size: 18),
                  label: Text(
                    'Need Review',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          PrimaryButton(
            text: 'Start Flashcard Session',
            icon: Icons.play_arrow,
            backgroundColor: AppColors.purpleAccent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FlashcardsPage()),
              );
            },
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFlipCard({required String question, required String answer}) {
    return Container(
      width: double.infinity,
      height: 320,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.cardWhite, AppColors.creamLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.honeyDark.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(color: AppColors.honeyYellow, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.honeyYellow.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Question',
              style: TextStyle(
                color: AppColors.honeyDark,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Text(
                question,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Center(
            child: Text(
              '👆 Tap to reveal answer',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('15 Practice Questions'),
          SizedBox(height: 16),
          ...List.generate(
            3,
            (i) => Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: _buildPracticeQuestion(i + 1),
            ),
          ),
          SizedBox(height: 16),
          PrimaryButton(
            text: 'Generate More Questions',
            icon: Icons.auto_awesome,
            backgroundColor: AppColors.successGreen,
            onPressed: () {},
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPracticeQuestion(int num) {
    final questions = [
      'An object is moving at constant velocity. Which statement is true?',
      'A 5kg object accelerates at 2m/s². Find the net force.',
      'When you push a wall, the wall pushes you back. Which law?',
    ];
    final options = [
      [
        'A. Net force is zero',
        'B. Forces are balanced',
        'C. Acceleration is constant',
        'D. Speed is increasing',
      ],
      ['A. 2.5 N', 'B. 10 N', 'C. 7 N', 'D. 3 N'],
      ['A. First Law', 'B. Second Law', 'C. Third Law', 'D. Law of Gravity'],
    ];
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.honeyYellow.withValues(alpha: 0.4),
                child: Text(
                  '$num',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.honeyDark,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  questions[num - 1],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...options[num - 1].map(
            (opt) => Padding(
              padding: EdgeInsets.only(top: 6),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.creamBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.honeyYellow.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConceptsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Key Concepts'),
          SizedBox(height: 16),
          ...[
            {
              'concept': 'Force Vectors',
              'level': 'High',
              'mastery': 72,
              'color': AppColors.successGreen,
            },
            {
              'concept': 'Free-Body Diagrams',
              'level': 'Medium',
              'mastery': 60,
              'color': AppColors.accentOrange,
            },
            {
              'concept': 'Friction & Inclined Planes',
              'level': 'Weak',
              'mastery': 30,
              'color': AppColors.errorRed,
            },
            {
              'concept': 'Uniform Circular Motion',
              'level': 'Medium',
              'mastery': 54,
              'color': AppColors.accentOrange,
            },
          ].map((c) {
            final concept = c['concept'] as String;
            final level = c['level'] as String;
            final mastery = c['mastery'] as int;
            final color = c['color'] as Color;

            return Padding(
              padding: EdgeInsets.only(bottom: 14),
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
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.science, color: color),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            concept,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  level,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: mastery / 100,
                              minHeight: 5,
                              backgroundColor: AppColors.progressBg,
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '$mastery%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.errorRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.errorRed.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, color: AppColors.errorRed),
                    SizedBox(width: 8),
                    Text(
                      'Weak Topics to Review',
                      style: TextStyle(
                        color: AppColors.errorRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                ...[
                  'Friction & Inclined Planes (30%)',
                  'Tension problems with multiple masses (22%)',
                ].map(
                  (w) => Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(Icons.adjust, color: AppColors.errorRed, size: 14),
                        SizedBox(width: 8),
                        Text(
                          w,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorRed,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(Icons.menu_book, size: 16),
                    label: Text(
                      'Study These Topics',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          PrimaryButton(
            text: 'Generate',
            icon: Icons.auto_awesome,
            backgroundColor: AppColors.purpleAccent,
            onPressed: () {},
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.honeyDark,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textPrimary,
                height: 1.5,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
