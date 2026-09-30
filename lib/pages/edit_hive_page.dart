import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import '../services/app_state.dart';

class EditHivePage extends StatefulWidget {
  final String hiveId;
  const EditHivePage({super.key, required this.hiveId});

  @override
  State<EditHivePage> createState() => _EditHivePageState();
}

class _EditHivePageState extends State<EditHivePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late String _selectedSubject;
  
  @override
  void initState() {
    super.initState();
    final hive = AppState().hives.firstWhere((h) => h.id == widget.hiveId);
    _nameController = TextEditingController(text: hive.name);
    _descController = TextEditingController(text: 'Study group for ${hive.subject}'); // Default desc if not in HiveData
    _selectedSubject = hive.subject;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      AppState().updateHive(
        widget.hiveId,
        _nameController.text.trim(),
        _selectedSubject,
        _descController.text.trim(),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hive updated successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          title: const Text('Edit Hive', style: TextStyle(color: AppColors.honeyDark, fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  label: 'Hive Name',
                  controller: _nameController,
                  prefixIcon: Icons.group,
                  validator: (v) {
                    final val = v?.trim() ?? '';
                    if (val.isEmpty) return 'Hive name is required';
                    if (val.length > 30) return 'Max 30 characters';
                    return null;
                  },
                ),
                CustomTextField(
                  label: 'Description',
                  controller: _descController,
                  prefixIcon: Icons.description,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'Save Changes',
                  onPressed: _handleSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
