import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';

class ReviewAnswersPage extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final List<int> correctIndices;

  const ReviewAnswersPage({
    super.key,
    required this.questions,
    required this.correctIndices,
  });

  @override
  State<ReviewAnswersPage> createState() => _ReviewAnswersPageState();
}

class _ReviewAnswersPageState extends State<ReviewAnswersPage> {
  int _current = 0;

  final List<String> _explanations = [
    "Newton's First Law (Law of Inertia) states that if the net force (sum of all forces) is zero, the object maintains constant velocity. This also means the forces are balanced — equal in magnitude and opposite in direction.",
    "Using F = m × a: 30 N = 10 kg × a → a = 30 / 10 = 3 m/s².",
    "The car seat pushes your back forward (car seat on you). Your body pushes the seat backward (you on seat). But more directly: your body resists acceleration forward because of its inertia — Newton's First Law.",
    "Work = Force × Distance in the direction of the force. W = 25 N × 4 m = 100 J.",
    "Action-reaction pairs MUST act on two different objects. Normal force acts on the object, and the object's weight also acts ON THE SAME OBJECT (from Earth). So they are NOT an action-reaction pair.",
    "Kinetic Energy = ½ mass × velocity². KE = ½mv². Speed is the rate component, so KE depends on both mass and velocity.",
    "The weight mg points downward. Break it into two perpendicular components: parallel = opposite = mg·sin(θ) and perpendicular = adjacent = mg·cos(θ) using trigonometry.",
    "The Law of Conservation of Momentum: total momentum before = total momentum after, provided no NET external forces act on the system.",
    "At max height the vertical velocity becomes zero INSTANTANEOUSLY, but gravity never stops acting. Acceleration is always g = 9.8 m/s² downward throughout the flight.",
    "Asphalt is rough with micro-level interlocking with rubber tires. Ice and Teflon are very smooth (low friction).",
  ];

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[_current];
    final isCorrect = widget.correctIndices.contains(_current);
    final correctIdx = q['correct'] as int;

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
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: AppColors.honeyDark)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Review Answers', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20) ?? TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('Question ${_current + 1} of ${widget.questions.length}', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: (isCorrect ? AppColors.successGreen : AppColors.errorRed).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(isCorrect ? Icons.check : Icons.close, size: 14, color: isCorrect ? AppColors.successGreen : AppColors.errorRed),
                          SizedBox(width: 4),
                          Text(isCorrect ? 'Correct' : 'Incorrect', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: isCorrect ? AppColors.successGreen : AppColors.errorRed)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (_current + 1) / widget.questions.length,
                    minHeight: 6,
                    backgroundColor: AppColors.progressBg,
                    valueColor: AlwaysStoppedAnimation<Color>(isCorrect ? AppColors.successGreen : AppColors.errorRed),
                  ),
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
                        padding: EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AppColors.cardWhite,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.honeyYellow.withValues(alpha: 0.5)),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: Offset(0, 6))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Question ${_current + 1}', style: TextStyle(color: AppColors.honeyDark, fontWeight: FontWeight.bold, fontSize: 11)),
                            SizedBox(height: 8),
                            Text(q['q'] as String, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.5)),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      ...(q['options'] as List).asMap().entries.map((e) {
                        final idx = e.key;
                        final opt = e.value as String;
                        final isSelectedAnswer = idx == correctIdx;
                        final wasStudentAnswer = !isCorrect && idx == (correctIdx == 0 ? 1 : correctIdx == 1 ? 0 : correctIdx - 1);

                        Color bg = AppColors.cardWhite;
                        Color border = AppColors.honeyYellow.withValues(alpha: 0.5);
                        Color textColor = AppColors.textPrimary;
                        IconData? icon;
                        String? badge;

                        if (isSelectedAnswer) {
                          bg = AppColors.successGreen.withValues(alpha: 0.12);
                          border = AppColors.successGreen;
                          textColor = AppColors.successGreen;
                          icon = Icons.check_circle;
                          badge = 'Correct Answer';
                        } else if (wasStudentAnswer && !isCorrect) {
                          bg = AppColors.errorRed.withValues(alpha: 0.12);
                          border = AppColors.errorRed;
                          textColor = AppColors.errorRed;
                          icon = Icons.cancel;
                          badge = 'Your Answer';
                        }

                        return Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: border, width: badge != null ? 2.5 : 1.5),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: icon != null ? border : Colors.transparent,
                                        border: Border.all(color: border, width: 2),
                                      ),
                                      child: Center(
                                        child: icon != null
                                            ? Icon(icon, color: AppColors.cardWhite, size: 16)
                                            : Text(String.fromCharCode(65 + idx), style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12)),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(child: Text(opt, style: TextStyle(color: textColor, fontWeight: badge != null ? FontWeight.w700 : FontWeight.w500, fontSize: 14, height: 1.4))),
                                    if (badge != null)
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(color: border, borderRadius: BorderRadius.circular(8)),
                                        child: Text(badge, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.purpleAccent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.purpleAccent.withValues(alpha: 0.35)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: AppColors.purpleAccent, shape: BoxShape.circle),
                                  child: Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                                ),
                                SizedBox(width: 10),
                                Text('AI Explanation', style: TextStyle(color: AppColors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: AppColors.successGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.celebration, color: AppColors.successGreen, size: 12),
                                      SizedBox(width: 3),
                                      Text('78%', style: TextStyle(color: AppColors.successGreen, fontWeight: FontWeight.bold, fontSize: 11)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              _explanations[_current],
                              style: TextStyle(color: AppColors.textPrimary, height: 1.6, fontSize: 13.5),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '✨ You explained well',
                              style: TextStyle(color: AppColors.successGreen, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '• Force causes acceleration\n• Mass affects inertia (Newton 1)\n• Unit of force: Newton',
                              style: TextStyle(color: AppColors.textPrimary, fontSize: 12, height: 1.7),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '🔥 Missing Concepts',
                              style: TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '• Net force (vector sum!)\n• Distinguish action-reaction pairs',
                              style: TextStyle(color: AppColors.textPrimary, fontSize: 12, height: 1.7),
                            ),
                            SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.errorRed,
                                      side: BorderSide(color: AppColors.errorRed),
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    icon: Icon(Icons.auto_stories, size: 16),
                                    label: Text('Study Topic', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.purpleAccent,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    icon: Icon(Icons.chat_bubble, size: 16),
                                    label: Text('Ask AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _current > 0 ? () => setState(() => _current--) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cardWhite,
                          foregroundColor: AppColors.textPrimary,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: AppColors.honeyYellow.withValues(alpha: 0.6))),
                          elevation: 0,
                          disabledBackgroundColor: AppColors.cardWhite.withValues(alpha: 0.4),
                        ),
                        icon: Icon(Icons.arrow_back_ios_new, size: 16),
                        label: Text('Previous', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _current < widget.questions.length - 1 ? () => setState(() => _current++) : () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.honeyDark,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: Text(_current == widget.questions.length - 1 ? 'Finish' : 'Next', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        label: Icon(Icons.arrow_forward_ios, size: 16),
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
