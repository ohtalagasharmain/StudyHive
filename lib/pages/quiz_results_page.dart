import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import 'review_answers_page.dart';
import 'adaptive_quiz_page.dart';

class QuizResultsPage extends StatefulWidget {
  final int correct;
  final int total;
  final String topic;
  final List<int> correctQuestions;
  final List<int> incorrectQuestions;
  final List<Map<String, dynamic>> questions;

  const QuizResultsPage({
    super.key,
    required this.correct,
    required this.total,
    required this.topic,
    required this.correctQuestions,
    required this.incorrectQuestions,
    required this.questions,
  });

  @override
  State<QuizResultsPage> createState() => _QuizResultsPageState();
}

class _QuizResultsPageState extends State<QuizResultsPage> with SingleTickerProviderStateMixin {
  late AnimationController _scoreController;
  late Animation<double> _scoreAnimation;

  int get score => (widget.correct / widget.total * 10).round();
  double get _accuracy => widget.correct / widget.total * 100;
  int get _masteryGain {
    if (_accuracy >= 90) return 22;
    if (_accuracy >= 80) return 18;
    if (_accuracy >= 70) return 12;
    if (_accuracy >= 60) return 6;
    return 2;
  }

  @override
  void initState() {
    super.initState();
    _scoreController = AnimationController(vsync: this, duration: Duration(milliseconds: 1400));
    _scoreAnimation = Tween<double>(begin: 0, end: widget.correct / widget.total).animate(CurvedAnimation(parent: _scoreController, curve: Curves.easeOutCubic));
    _scoreController.forward();
  }

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _weakTopics {
    return [
      {'topic': 'Work and Energy', 'pct': 60, 'color': AppColors.accentOrange},
      {'topic': 'Friction (ISS-100%)', 'pct': 30, 'color': AppColors.errorRed},
      {'topic': 'Inclined (ISS-18%)', 'pct': 22, 'color': AppColors.errorRed},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bgGradient = _accuracy >= 80
        ? LinearGradient(colors: [AppColors.successGreen.withValues(alpha: 0.18), AppColors.cardWhite], begin: Alignment.topCenter, end: Alignment.bottomCenter)
        : _accuracy >= 60
            ? LinearGradient(colors: [AppColors.accentOrange.withValues(alpha: 0.18), AppColors.cardWhite], begin: Alignment.topCenter, end: Alignment.bottomCenter)
            : LinearGradient(colors: [AppColors.errorRed.withValues(alpha: 0.15), AppColors.cardWhite], begin: Alignment.topCenter, end: Alignment.bottomCenter);
    final headerColor = _accuracy >= 80 ? AppColors.successGreen : _accuracy >= 60 ? AppColors.accentOrange : AppColors.errorRed;

    return HoneycombBackground(
      showGradient: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: bgGradient,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: headerColor.withValues(alpha: 0.4), width: 2.5),
                  ),
                  child: Column(
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 900),
                        builder: (ctx, value, child) => Transform.scale(scale: value, child: child),
                        child: Text('Great Job! 🎉', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: headerColor) ?? TextStyle(color: headerColor, fontSize: 28, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 8),
                      Text(widget.topic, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      SizedBox(height: 28),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 180,
                            height: 180,
                            child: AnimatedBuilder(
                              animation: _scoreAnimation,
                              builder: (ctx, _) {
                                return CustomPaint(
                                  painter: ScoreRingPainter(
                                    progress: _scoreAnimation.value,
                                    color: headerColor,
                                  ),
                                );
                              },
                            ),
                          ),
                          Column(
                            children: [
                              AnimatedBuilder(
                                animation: _scoreAnimation,
                                builder: (ctx, _) {
                                  final val = (_scoreAnimation.value * 10).round();
                                  return Text(
                                    '$val / 10',
                                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  );
                                },
                              ),
                              Text('Your Score', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, letterSpacing: 1)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatCol('Accuracy', '${_accuracy.toStringAsFixed(0)}%', headerColor),
                            VerticalDivider(color: AppColors.honeyCombLine, thickness: 1, indent: 8, endIndent: 8),
                            _buildStatCol('Mastery Improved', '+$_masteryGain%', AppColors.successGreen),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        icon: Icons.check_circle,
                        label: 'Correct',
                        value: '${widget.correct}',
                        color: AppColors.successGreen,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        icon: Icons.cancel,
                        label: 'Incorrect',
                        value: '${widget.total - widget.correct}',
                        color: AppColors.errorRed,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.honeyYellow.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bar_chart, color: AppColors.successGreen),
                          SizedBox(width: 8),
                          Text('Accuracy History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Spacer(),
                          Text('7 day trend', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                        ],
                      ),
                      SizedBox(height: 18),
                      SizedBox(
                        height: 80,
                        child: CustomPaint(
                          size: Size(double.infinity, 80),
                          painter: SparklinePainter(
                            data: [0.55, 0.62, 0.60, 0.71, 0.73, 0.78, _accuracy / 100],
                            color: AppColors.successGreen,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Today'].map(
                          (d) => Text(d, style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
                        ).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber, color: AppColors.errorRed),
                          SizedBox(width: 8),
                          Text('Weak Topics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.errorRed)),
                        ],
                      ),
                      SizedBox(height: 14),
                      ..._weakTopics.map((w) => Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Text(w['topic'] as String, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                                    Text('${w['pct']}%', style: TextStyle(color: w['color'] as Color, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ],
                                ),
                                SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: (w['pct'] as int) / 100,
                                    minHeight: 5,
                                    backgroundColor: AppColors.cardWhite,
                                    valueColor: AlwaysStoppedAnimation<Color>(w['color'] as Color),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.errorRed,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: Icon(Icons.menu_book, size: 18),
                          label: Text('Study Weak Topics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                PrimaryButton(
                  text: 'Review Answers',
                  icon: Icons.assignment,
                  backgroundColor: AppColors.purpleAccent,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewAnswersPage(
                          questions: widget.questions,
                          correctIndices: widget.correctQuestions,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 12),
                SecondaryButton(
                  text: 'Retry Quiz',
                  icon: Icons.refresh,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdaptiveQuizPage(
                          type: 'Practice Quiz',
                          topic: widget.topic,
                          difficulty: 'Medium',
                          numQuestions: widget.total,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => Navigator.popUntil(context, (r) => r.isFirst || r.settings.name == '/home'),
                  icon: Icon(Icons.home, color: AppColors.honeyDark),
                  label: Text('Continue to Dashboard', style: TextStyle(color: AppColors.honeyDark, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCol(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 2),
          Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String label, required String value, required Color color}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color),
          ),
          SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class ScoreRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  ScoreRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = AppColors.progressBg
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = color
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 7;

    canvas.drawCircle(center, radius, bgPaint);

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -3.14159 / 2, progress * 2 * 3.14159, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant ScoreRingPainter oldDelegate) => oldDelegate.progress != progress;
}

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  SparklinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stepX = w / (data.length - 1);

    final linePath = Path();
    final fillPath = Path();
    final dots = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = h - (data[i] * h);
      dots.add(Offset(x, y));
      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(dots.last.dx, h);
    fillPath.lineTo(dots.first.dx, h);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.02)]).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);

    for (var d in dots) {
      final circlePaint = Paint()..color = AppColors.cardWhite..style = PaintingStyle.fill;
      canvas.drawCircle(d, 4, circlePaint);
      canvas.drawCircle(d, 4, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2);
    }
    final last = dots.last;
    final pulsePaint = Paint()..color = color.withValues(alpha: 0.25);
    canvas.drawCircle(last, 7, pulsePaint);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) => oldDelegate.data != data;
}
