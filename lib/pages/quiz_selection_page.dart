import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import 'adaptive_quiz_page.dart';

class QuizSelectionPage extends StatefulWidget {
  const QuizSelectionPage({super.key});

  @override
  State<QuizSelectionPage> createState() => _QuizSelectionPageState();
}

class _QuizSelectionPageState extends State<QuizSelectionPage> {
  int _selectedType = 0; // 0=Adaptive, 1=Practice, 2=Hive
  String? _selectedTopic = "Newton's Laws";
  String _difficulty = 'Medium';
  int _numQuestions = 10;

  final List<String> _topics = [
    "Newton's Laws", 'Kinematics', 'Work, Energy & Power',
    'Friction', 'Momentum', 'Circular Motion', 'Gravitation'
  ];
  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];

  @override
  Widget build(BuildContext context) {
    final types = [
      ('Adaptive Quiz', Icons.auto_awesome, 'AI adjusts difficulty based on answers', AppColors.honeyDark),
      ('Practice Quiz', Icons.palette_outlined, 'Fixed questions for focused review', AppColors.purpleAccent),
      ('Hive Quiz', Icons.hive, 'Compete with your hive members', Color(0xFF42A5F5)),
    ];

    return HoneycombBackground(
      showGradient: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(onPressed: () => Navigator.maybePop(context), icon: Icon(Icons.arrow_back, color: AppColors.honeyDark)),
                    SizedBox(width: 8),
                    Text('Quizzes', style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
                SizedBox(height: 8),
                Text('Choose a quiz type to get started', style: TextStyle(color: AppColors.textSecondary)),
                SizedBox(height: 24),
                Text('Choose Quiz Type', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 12),
                ...types.asMap().entries.map((e) {
                  final i = e.key;
                  final t = e.value;
                  final selected = _selectedType == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = i),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selected ? (t.$4).withValues(alpha: 0.08) : AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: selected ? t.$4 : AppColors.honeyYellow.withValues(alpha: 0.5), width: selected ? 2.5 : 1.5),
                        boxShadow: selected ? [BoxShadow(color: (t.$4).withValues(alpha: 0.15), blurRadius: 12, offset: Offset(0, 4))] : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(color: (t.$4).withValues(alpha: 0.18), borderRadius: BorderRadius.circular(14)),
                            child: Icon(t.$2, color: t.$4, size: 26),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.$1, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                                SizedBox(height: 4),
                                Text(t.$3, style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4)),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          if (selected) Icon(Icons.check_circle, color: t.$4),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: 24),
                Text('Topic', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.honeyYellow, width: 2)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedTopic,
                      isExpanded: true,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      items: _topics.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => setState(() => _selectedTopic = v),
                      dropdownColor: AppColors.cardWhite,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text('Difficulty', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 12),
                Row(
                  children: _difficulties.map((d) {
                    final selected = _difficulty == d;
                    final colors = {
                      'Easy': AppColors.successGreen,
                      'Medium': AppColors.accentOrange,
                      'Hard': AppColors.errorRed,
                    };
                    final color = colors[d]!;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _difficulty = d),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          margin: EdgeInsets.only(right: d != 'Hard' ? 10 : 0),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: selected ? color : AppColors.cardWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: selected ? color : AppColors.honeyYellow.withValues(alpha: 0.5), width: selected ? 2 : 1.5),
                          ),
                          child: Center(
                            child: Text(
                              d,
                              style: TextStyle(color: selected ? Colors.white : color, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 24),
                Text('Number of Questions', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(color: AppColors.cardWhite, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.honeyYellow.withValues(alpha: 0.5))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('5', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 12)),
                          Text('$_numQuestions questions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.honeyDark)),
                          Text('50', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 12)),
                        ],
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 6,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                          activeTrackColor: AppColors.honeyDark,
                          inactiveTrackColor: AppColors.progressBg,
                          thumbColor: AppColors.honeyDark,
                          overlayColor: AppColors.honeyDark.withValues(alpha: 0.15),
                        ),
                        child: Slider(
                          value: _numQuestions.toDouble(),
                          min: 5,
                          max: 50,
                          divisions: 9,
                          label: '$_numQuestions',
                          onChanged: (v) => setState(() => _numQuestions = v.toInt()),
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        children: [5, 10, 15, 20, 30].map((n) {
                          final selected = _numQuestions == n;
                          return GestureDetector(
                            onTap: () => setState(() => _numQuestions = n),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: selected ? AppColors.honeyDark : AppColors.creamBackground,
                                borderRadius: BorderRadius.circular(10),
                                border: selected ? null : Border.all(color: AppColors.honeyYellow),
                              ),
                              child: Text('$n', style: TextStyle(color: selected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                PrimaryButton(
                  text: 'Start Quiz',
                  icon: Icons.play_arrow,
                  backgroundColor: types[_selectedType].$4,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdaptiveQuizPage(
                          type: types[_selectedType].$1,
                          topic: _selectedTopic!,
                          difficulty: _difficulty,
                          numQuestions: _numQuestions,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
