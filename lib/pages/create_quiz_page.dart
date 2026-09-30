import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import '../services/app_state.dart';
import 'adaptive_quiz_page.dart';

class CreateQuizPage extends StatefulWidget {
  final String hiveId;
  const CreateQuizPage({super.key, required this.hiveId});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _formKey = GlobalKey<FormState>();
  int _numQuestions = 5;
  String? _selectedTopic;
  String _difficulty = 'Medium';
  
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final hive = AppState().hives.firstWhere((h) => h.id == widget.hiveId);
        final topics = hive.materials.map((m) => m.title).toList();
        if (topics.isEmpty) topics.add('General ${hive.subject}');

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
              title: const Text('Create Hive Quiz', 
                style: TextStyle(color: AppColors.honeyDark, fontWeight: FontWeight.bold)),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Topic Source', 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedTopic,
                      items: topics.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (val) => setState(() => _selectedTopic = val),
                      decoration: const InputDecoration(hintText: 'Select a material or topic'),
                      validator: (val) => val == null ? 'Please select a topic' : null,
                    ),
                    const SizedBox(height: 24),
                    const Text('Number of Questions', 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _numButton(Icons.remove, () {
                          if (_numQuestions > 1) setState(() => _numQuestions--);
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text('$_numQuestions', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        _numButton(Icons.add, () {
                          if (_numQuestions < 20) setState(() => _numQuestions++);
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Initial Difficulty', 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Row(
                      children: ['Easy', 'Medium', 'Hard'].map((d) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(d),
                          selected: _difficulty == d,
                          onSelected: (selected) {
                            if (selected) setState(() => _difficulty = d);
                          },
                          selectedColor: AppColors.honeyDark,
                          labelStyle: TextStyle(color: _difficulty == d ? Colors.white : AppColors.textPrimary),
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 40),
                    PrimaryButton(
                      text: 'Generate Quiz',
                      icon: Icons.auto_awesome,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdaptiveQuizPage(
                                type: 'Adaptive Quiz',
                                topic: _selectedTopic!,
                                difficulty: _difficulty,
                                numQuestions: _numQuestions,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _numButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.honeyYellow.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(icon: Icon(icon, color: AppColors.honeyDark), onPressed: onTap),
    );
  }
}
