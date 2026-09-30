import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import '../services/app_state.dart';
import 'hive_overview_page.dart';

class StudyTask {
  final String id;
  final String title;
  final String duration;
  final int durationMinutes;
  final String hiveSubject;
  bool isCompleted;

  StudyTask({
    required this.id,
    required this.title,
    required this.duration,
    required this.durationMinutes,
    required this.hiveSubject,
    this.isCompleted = false,
  });
}

class StudyPlanPage extends StatefulWidget {
  const StudyPlanPage({super.key});

  @override
  State<StudyPlanPage> createState() => _StudyPlanPageState();
}

class _StudyPlanPageState extends State<StudyPlanPage> {
  final List<StudyTask> _tasks = [
    StudyTask(
      id: '1',
      title: "Review Newton's Laws & Formulas",
      duration: '25 mins',
      durationMinutes: 25,
      hiveSubject: 'Physics',
      isCompleted: true,
    ),
    StudyTask(
      id: '2',
      title: 'Practice Calculus Derivatives Quiz',
      duration: '20 mins',
      durationMinutes: 20,
      hiveSubject: 'Mathematics',
      isCompleted: false,
    ),
    StudyTask(
      id: '3',
      title: 'Chemistry Periodic Table Review',
      duration: '15 mins',
      durationMinutes: 15,
      hiveSubject: 'Chemistry',
      isCompleted: false,
    ),
  ];

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final durationController = TextEditingController(text: '15');
    String selectedSubject = 'Physics';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Study Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Duration (Minutes)'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedSubject,
              items: ['Physics', 'Mathematics', 'Chemistry', 'Biology', 'General Study']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                if (val != null) selectedSubject = val;
              },
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final mins = int.tryParse(durationController.text.trim()) ?? 15;
              if (title.isNotEmpty) {
                setState(() {
                  _tasks.add(StudyTask(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                    duration: '$mins mins',
                    durationMinutes: mins,
                    hiveSubject: selectedSubject,
                  ));
                });
                Navigator.pop(dialogContext);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.honeyDark),
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _tasks.where((t) => t.isCompleted).length;
    final progress = _tasks.isEmpty ? 0.0 : completedCount / _tasks.length;

    return HoneycombBackground(
      showGradient: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.honeyDark),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Today's Study Plan",
            style: TextStyle(color: AppColors.honeyDark, fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddTaskDialog,
          backgroundColor: AppColors.honeyDark,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Add Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$completedCount of ${_tasks.length} Completed',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            color: AppColors.honeyDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: AppColors.progressBg,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.honeyDark),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Tasks List',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),

              if (_tasks.isEmpty)
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text('No study tasks planned for today.'),
                  ),
                )
              else
                ..._tasks.map((task) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CheckboxListTile(
                    activeColor: AppColors.honeyDark,
                    value: task.isCompleted,
                    onChanged: (val) {
                      setState(() {
                        task.isCompleted = val ?? false;
                        if (task.isCompleted) {
                          AppState().addSession(UserSession(
                            startTime: DateTime.now().subtract(Duration(minutes: task.durationMinutes)),
                            endTime: DateTime.now(),
                            topic: task.title,
                          ));
                        }
                      });
                    },
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text('${task.hiveSubject} • ${task.duration}'),
                    secondary: IconButton(
                      icon: const Icon(Icons.play_circle_fill, color: AppColors.honeyDark, size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HiveOverviewPage()),
                        );
                      },
                    ),
                  ),
                )),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
