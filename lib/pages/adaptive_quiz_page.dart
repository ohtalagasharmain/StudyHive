import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import 'quiz_results_page.dart';
import '../services/app_state.dart';

class AdaptiveQuizPage extends StatefulWidget {
  final String type;
  final String topic;
  final String difficulty;
  final int numQuestions;

  const AdaptiveQuizPage({
    super.key,
    required this.type,
    required this.topic,
    required this.difficulty,
    required this.numQuestions,
  });

  @override
  State<AdaptiveQuizPage> createState() => _AdaptiveQuizPageState();
}

class _AdaptiveQuizPageState extends State<AdaptiveQuizPage> {
  int _current = 0;
  int? _selectedOption;
  bool _showFeedback = false;
  bool? _isCorrect;
  final Set<int> _correct = {};
  final Set<int> _incorrect = {};
  bool _showHint = false;
  bool _isAdaptive = false;
  int _consecutiveCorrect = 0;
  String _currentDifficulty = 'Medium';
  late final List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();
    _isAdaptive = widget.type == 'Adaptive Quiz';
    _currentDifficulty = widget.difficulty;
    
    // Slice or repeat hardcoded questions to match requested count
    final allQuestions = [
      {
        'q': "An object is moving at a constant velocity. Which of the following is true?",
        'options': [
          'Net force is zero',
          'Forces are balanced',
          'Acceleration is constant',
          'Speed is increasing',
        ],
        'correct': 0,
        'hint': "Newton's First Law — objects in motion stay in motion unless a net force acts on them.",
        'diff': 'Easy',
      },
      {
        'q': 'A 10-kg object experiences a net force of 30 N. What is its acceleration?',
        'options': ['300 m/s²', '0.33 m/s²', '3 m/s²', '10 m/s²'],
        'correct': 2,
        'hint': 'Use F = m × a. Solve for a = F/m.',
        'diff': 'Easy',
      },
      {
        'q': 'Which law best explains why you feel pushed back when a car accelerates?',
        'options': [
          "Newton's 1st Law",
          "Newton's 2nd Law",
          "Newton's 3rd Law",
          'Law of Gravitation',
        ],
        'correct': 0,
        'hint':
            'Your body resists the change in motion — it wants to stay at rest.',
        'diff': 'Medium',
      },
      {
        'q': 'A 25-N force pushes an object 4 m. How much work is done?',
        'options': ['6.25 J', '29 J', '100 J', '21 J'],
        'correct': 2,
        'hint': 'Work (W) = Force (F) × distance (d). Unit is Joules (J).',
        'diff': 'Medium',
      },
      {
        'q': 'Which of the following is NOT an action-reaction pair?',
        'options': [
          'Earth pulling you down and you pulling Earth up',
          'Foot pushing ground and ground pushing foot',
          'Rocket pushing gases down and gases pushing rocket up',
          'Normal force and weight on a flat surface',
        ],
        'correct': 3,
        'hint': 'Action-reaction forces must act on DIFFERENT objects. Both normal and weight act on the same object.',
        'diff': 'Hard',
      },
      {
        'q': 'Kinetic energy depends on which two quantities?',
        'options': [
          'Force and distance',
          'Mass and velocity',
          'Mass and height',
          'Time and power',
        ],
        'correct': 1,
        'hint': 'KE = ½ m v²',
        'diff': 'Easy',
      },
      {
        'q': 'An incline has angle θ with the horizontal. What is the component of weight parallel to the incline?',
        'options': ['mg·cos(θ)', 'mg·sin(θ)', 'mg·tan(θ)', 'mg'],
        'correct': 1,
        'hint': 'Parallel = opposite side of the triangle = sin. Perpendicular = adjacent = cos.',
        'diff': 'Hard',
      },
      {
        'q': 'Momentum is conserved under which condition?',
        'options': [
          'Always',
          'Only in elastic collisions',
          'When net external force is zero',
          'When KE is constant',
        ],
        'correct': 2,
        'hint': 'Law of Conservation of Momentum applies to isolated systems.',
        'diff': 'Medium',
      },
      {
        'q': 'A ball is thrown straight up. At maximum height, its acceleration is:',
        'options': ['0 m/s²', '9.8 m/s² upward', '9.8 m/s² downward', 'Varies'],
        'correct': 2,
        'hint': 'Gravity always acts downward with g ≈ 9.8 m/s² even at the top of the trajectory.',
        'diff': 'Medium',
      },
      {
        'q': 'Which surface would have the highest coefficient of friction?',
        'options': ['Ice on ice', 'Wet road', 'Dry asphalt', 'Teflon on steel'],
        'correct': 2,
        'hint': 'Rougher, more interlocking surfaces = higher friction.',
        'diff': 'Easy',
      },
    ];

    _questions = List.generate(
      widget.numQuestions,
      (i) => allQuestions[i % allQuestions.length],
    );
  }

  void _selectOption(int idx) {
    if (_showFeedback) return;
    setState(() {
      _selectedOption = idx;
    });
  }

  void _submitAnswer() {
    if (_selectedOption == null || _showFeedback) return;
    final correct = _selectedOption == _questions[_current]['correct'];
    setState(() {
      _showFeedback = true;
      _isCorrect = correct;
      if (correct) {
        _correct.add(_current);
        _consecutiveCorrect++;
        if (_isAdaptive) {
          if (_consecutiveCorrect >= 2 && _currentDifficulty != 'Hard') {
            _currentDifficulty = _currentDifficulty == 'Easy'
                ? 'Medium'
                : 'Hard';
            _consecutiveCorrect = 0;
          }
        }
      } else {
        _incorrect.add(_current);
        _consecutiveCorrect = 0;
        if (_isAdaptive) {
          if (_currentDifficulty != 'Easy') {
            _currentDifficulty = _currentDifficulty == 'Hard'
                ? 'Medium'
                : 'Easy';
          }
        }
      }
    });
  }

  void _nextQuestion() {
    if (_current < _questions.length - 1) {
      setState(() {
        _current++;
        _selectedOption = null;
        _showFeedback = false;
        _isCorrect = null;
        _showHint = false;
      });
    } else {
      // Record study activity
      final now = DateTime.now();
      AppState().addSession(UserSession(
        startTime: now.subtract(const Duration(minutes: 15)), // Mock duration
        endTime: now,
        topic: widget.topic,
      ));
      
      AppState().addQuizResult(QuizResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        topic: widget.topic,
        score: _correct.length,
        total: _questions.length,
        date: now,
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultsPage(
            correct: _correct.length,
            total: _questions.length,
            topic: widget.topic,
            correctQuestions: _correct.toList(),
            incorrectQuestions: _incorrect.toList(),
            questions: _questions,
          ),
        ),
      );
    }
  }

  void _exitQuiz() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Exit Quiz?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Your progress will be lost.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text(
              'Exit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _effectiveDiffColor(String diff) {
    switch (diff) {
      case 'Easy':
        return AppColors.successGreen;
      case 'Medium':
        return AppColors.accentOrange;
      case 'Hard':
        return AppColors.errorRed;
      default:
        return AppColors.accentOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_current + 1) / _questions.length;
    final q = _questions[_current];
    final diffColor = (q['diff'] as String) == 'Easy'
        ? AppColors.successGreen
        : (q['diff'] as String) == 'Medium'
        ? AppColors.accentOrange
        : AppColors.errorRed;
    
    final effectiveDiff = _isAdaptive ? _currentDifficulty : widget.difficulty;
    final effectiveDiffColor = _effectiveDiffColor(effectiveDiff);

    return HoneycombBackground(
      showGradient: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _exitQuiz,
                      icon: Icon(Icons.close, color: AppColors.honeyDark),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question ${_current + 1}/${_questions.length}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.honeyDark,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 7,
                                backgroundColor: AppColors.progressBg,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.honeyDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isAdaptive)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: effectiveDiffColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          effectiveDiff,
                          style: TextStyle(
                            color: effectiveDiffColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.quiz, color: AppColors.honeyDark, size: 16),
                    SizedBox(width: 6),
                    Text(
                      widget.type,
                      style: TextStyle(
                        color: AppColors.honeyDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.bookmark,
                      color: AppColors.textSecondary,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      widget.topic,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.cardWhite,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.honeyYellow.withValues(alpha: 0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: diffColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Difficulty: ${q['diff']}',
                                style: TextStyle(
                                  color: diffColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              q['q'] as String,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      ...(q['options'] as List).asMap().entries.map((e) {
                        final idx = e.key;
                        final opt = e.value as String;
                        final isSelected = _selectedOption == idx;
                        final isCorrectOpt = idx == q['correct'];
                        Color bg = AppColors.cardWhite;
                        Color border = AppColors.honeyYellow.withValues(
                          alpha: 0.5,
                        );
                        Color textColor = AppColors.textPrimary;
                        IconData? icon;

                        if (_showFeedback) {
                          if (isCorrectOpt) {
                            bg = AppColors.successGreen.withValues(alpha: 0.12);
                            border = AppColors.successGreen;
                            textColor = AppColors.successGreen;
                            icon = Icons.check_circle;
                          } else if (isSelected && !isCorrectOpt) {
                            bg = AppColors.errorRed.withValues(alpha: 0.12);
                            border = AppColors.errorRed;
                            textColor = AppColors.errorRed;
                            icon = Icons.cancel;
                          }
                        } else if (isSelected) {
                          bg = AppColors.honeyYellow.withValues(alpha: 0.2);
                          border = AppColors.honeyDark;
                        }

                        return GestureDetector(
                          onTap: () => _selectOption(idx),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            margin: EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: border,
                                width: isSelected || _showFeedback ? 2.5 : 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? (bg == AppColors.cardWhite
                                                ? AppColors.honeyDark
                                                : border)
                                          : AppColors.textSecondary.withValues(
                                              alpha: 0.4,
                                            ),
                                      width: 2,
                                    ),
                                    color: isSelected
                                        ? border.withValues(alpha: 0.3)
                                        : Colors.transparent,
                                  ),
                                  child: Center(
                                    child: icon != null
                                        ? Icon(icon, color: border, size: 18)
                                        : (isSelected
                                              ? Icon(
                                                  Icons.circle,
                                                  color: border,
                                                  size: 12,
                                                )
                                              : Text(
                                                  String.fromCharCode(65 + idx),
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.textSecondary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                )),
                                  ),
                                ),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    opt,
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      if (_showHint) ...[
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.honeyYellow.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.honeyYellow),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.lightbulb, color: AppColors.honeyDark),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '💡 ${q['hint'] as String}',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    height: 1.5,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (!_showFeedback) ...[
                        SizedBox(height: 10),
                        Center(
                          child: TextButton.icon(
                            onPressed: _showHint
                                ? null
                                : () => setState(() => _showHint = true),
                            icon: Icon(
                              Icons.help_outline,
                              color: _showHint
                                  ? AppColors.textSecondary
                                  : AppColors.honeyDark,
                              size: 18,
                            ),
                            label: Text(
                              _showHint ? 'Hint used' : 'Show Hint',
                              style: TextStyle(
                                color: _showHint
                                    ? AppColors.textSecondary
                                    : AppColors.honeyDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (_showFeedback) ...[
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                (_isCorrect!
                                        ? AppColors.successGreen
                                        : AppColors.errorRed)
                                    .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: _isCorrect!
                                  ? AppColors.successGreen
                                  : AppColors.errorRed,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _isCorrect!
                                    ? Icons.celebration
                                    : Icons.sentiment_dissatisfied,
                                color: _isCorrect!
                                    ? AppColors.successGreen
                                    : AppColors.errorRed,
                                size: 28,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _isCorrect!
                                          ? 'Correct! Great job! 🎉'
                                          : 'Not quite! 😔',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: _isCorrect!
                                            ? AppColors.successGreen
                                            : AppColors.errorRed,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _isCorrect!
                                          ? "You've got this concept down!"
                                          : 'Review the correct answer above and try again next time.',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 12,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    if (!_showFeedback)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _submitAnswer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.honeyDark,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: AppColors.textSecondary
                                .withValues(alpha: 0.3),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: Icon(Icons.check, size: 20),
                          label: Text(
                            _selectedOption == null
                                ? 'Select an answer'
                                : 'Submit Answer',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _current == _questions.length - 1
                                ? AppColors.successGreen
                                : AppColors.purpleAccent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: Icon(
                            _current == _questions.length - 1
                                ? Icons.flag
                                : Icons.arrow_forward,
                            size: 20,
                          ),
                          label: Text(
                            _current == _questions.length - 1
                                ? 'See Results'
                                : 'Next Question',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
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
}
