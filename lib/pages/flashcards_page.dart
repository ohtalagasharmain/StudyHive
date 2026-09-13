import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  int _currentIndex = 0;
  bool _shuffled = false;
  final Set<int> _known = {};
  final Set<int> _review = {};

  final List<Map<String, String>> _cards = [
    {
      'q': "What is Newton's First Law of Motion also known as?",
      'a': "The Law of Inertia — Objects maintain their state of motion unless acted upon by a net force.",
    },
    {
      'q': 'Write the mathematical formula for Newton\'s Second Law.',
      'a': 'F = m × a\n\nForce = mass × acceleration\n(F in Newtons, m in kg, a in m/s²)',
    },
    {
      'q': 'What does Newton\'s Third Law state?',
      'a': 'For every action force, there is an equal and opposite reaction force.\n\nAction-Reaction pairs act on DIFFERENT objects.',
    },
    {
      'q': 'Define inertia and what it depends on.',
      'a': 'Inertia is the tendency of an object to resist changes in motion.\n\nIt depends SOLELY on MASS — more mass = more inertia.',
    },
    {
      'q': 'What is the difference between mass and weight?',
      'a': '• Mass: amount of matter (kg), constant everywhere\n• Weight: force of gravity (N = mg), changes with gravity\n\nWeight = mass × 9.8 m/s² on Earth',
    },
    {
      'q': 'When does equilibrium occur?',
      'a': 'When the net force on an object is zero (ΣF = 0)\n\n• Static equilibrium: object at rest\n• Dynamic equilibrium: object moving at constant velocity',
    },
    {
      'q': 'Define normal force.',
      'a': 'The perpendicular contact force exerted by a surface on an object pressing against it.\n\nOn a flat surface: N = mg\nOn incline: N = mg·cos(θ)',
    },
    {
      'q': 'What are the 3 types of friction?',
      'a': '1. Static friction (f_s): prevents sliding, adjusts up to max\n2. Kinetic friction (f_k): acts during sliding, constant\n3. Rolling friction: acts on rolling objects, weakest\n\nAlways: f_s,max > f_k > f_rolling',
    },
    {
      'q': 'What is terminal velocity?',
      'a': 'The constant maximum velocity reached by a falling object when air resistance equals weight.\n\nNet force = 0 → Acceleration = 0 → Constant speed',
    },
    {
      'q': 'How do you calculate net force with multiple forces?',
      'a': 'Break forces into x and y components, then sum:\n\nΣF_x = ma_x\nΣF_y = ma_y\n\nUse tip-to-tail vector addition or components method.',
    },
    {
      'q': 'What is the unit of force?',
      'a': 'The Newton (N)\n\n1 N = 1 kg·m/s²\n\nEquivalent to the force that gives a 1 kg mass an acceleration of 1 m/s².',
    },
    {
      'q': 'Define acceleration.',
      'a': 'The rate of change of velocity per unit of time.\n\na = Δv / Δt\nUnit: m/s²\nVector quantity — has magnitude and direction.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_flipController.isAnimating) return;
    if (_flipAnimation.value == 0) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  void _goTo(int index) {
    setState(() {
      _currentIndex = index;
    });
    _flipController.value = 0;
  }

  void _nextCard() {
    if (_currentIndex < _cards.length - 1) _goTo(_currentIndex + 1);
  }

  void _prevCard() {
    if (_currentIndex > 0) _goTo(_currentIndex - 1);
  }

  void _shuffle() {
    setState(() {
      _cards.shuffle();
      _currentIndex = 0;
      _shuffled = true;
    });
    _flipController.value = 0;
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Flashcards',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            "Newton's Laws of Motion",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _shuffle,
                      icon: Icon(
                        Icons.shuffle,
                        color: _shuffled
                            ? AppColors.honeyDark
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Card ${_currentIndex + 1} of ${_cards.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.honeyDark,
                        fontSize: 13,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(
                          255,
                          220,
                          115,
                          0,
                        ).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${((_currentIndex + 1) / _cards.length * 100).toInt()}% Complete',
                        style: TextStyle(
                          color: AppColors.purpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / _cards.length,
                    minHeight: 6,
                    backgroundColor: AppColors.progressBg,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.honeyDark,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: _flipCard,
                    child: AnimatedBuilder(
                      animation: _flipAnimation,
                      builder: (context, child) {
                        final angle = _flipAnimation.value * 3.14159;
                        final transform = Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle);
                        return Transform(
                          transform: transform,
                          alignment: Alignment.center,
                          child: angle > 1.5708
                              ? Transform(
                                  transform: Matrix4.identity()
                                    ..rotateY(3.14159),
                                  alignment: Alignment.center,
                                  child: _buildAnswerCard(),
                                )
                              : _buildQuestionCard(),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _currentIndex > 0 ? _prevCard : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cardWhite,
                          foregroundColor: AppColors.textPrimary,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: AppColors.honeyYellow),
                          ),
                          elevation: 0,
                        ),
                        icon: Icon(Icons.arrow_back_ios_new, size: 16),
                        label: Text(
                          'Previous',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _currentIndex < _cards.length - 1
                            ? _nextCard
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cardWhite,
                          foregroundColor: AppColors.textPrimary,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: AppColors.honeyYellow),
                          ),
                          elevation: 0,
                        ),
                        icon: Text(
                          'Next',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        label: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _known.add(_currentIndex);
                            _review.remove(_currentIndex);
                          });
                          if (_currentIndex < _cards.length - 1) _nextCard();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _known.contains(_currentIndex)
                              ? AppColors.successGreen.withValues(alpha: 0.8)
                              : AppColors.successGreen,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: Icon(Icons.check_circle, size: 18),
                        label: Text(
                          'Know It',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _review.add(_currentIndex);
                            _known.remove(_currentIndex);
                          });
                          if (_currentIndex < _cards.length - 1) _nextCard();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _review.contains(_currentIndex)
                              ? AppColors.errorRed.withValues(alpha: 0.8)
                              : AppColors.errorRed,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: Icon(Icons.refresh, size: 18),
                        label: Text(
                          'Review Again',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.successGreen,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${_known.length} Known',
                    style: TextStyle(
                      color: AppColors.successGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.refresh, color: AppColors.errorRed, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '${_review.length} To Review',
                    style: TextStyle(
                      color: AppColors.errorRed,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.shuffle, color: AppColors.textSecondary, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '${_cards.length - _known.length - _review.length} Remaining',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.cardWhite, AppColors.creamLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.honeyYellow, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.honeyDark.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.honeyYellow.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.help_outline, color: AppColors.honeyDark, size: 16),
                SizedBox(width: 6),
                Text(
                  'Question',
                  style: TextStyle(
                    color: AppColors.honeyDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  _cards[_currentIndex]['q']!,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Icon(Icons.touch_app, color: AppColors.textSecondary, size: 22),
              SizedBox(height: 6),
              Text(
                '👆 Tap card to reveal answer',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 251, 255, 37).withValues(alpha: 0.08),
            AppColors.cardWhite,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color.fromARGB(255, 255, 150, 37).withValues(alpha: 0.5),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(
              255,
              220,
              115,
              0,
            ).withValues(alpha: 0.15),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                255,
                255,
                102,
                0,
              ).withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lightbulb,
                  color: const Color.fromARGB(255, 255, 102, 0),
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'Answer',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 102, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  _cards[_currentIndex]['a']!,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Text(
            '👆 Tap to flip back',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
