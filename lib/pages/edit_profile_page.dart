import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import '../services/app_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _schoolController;
  String? _imagePath;
  bool _isUpdating = false;
  
  @override
  void initState() {
    super.initState();
    final user = AppState().user;
    _nameController = TextEditingController(text: user.name);
    _usernameController = TextEditingController(text: user.username);
    _bioController = TextEditingController(text: user.bio);
    _schoolController = TextEditingController(text: user.school);
    _imagePath = user.profilePicturePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.honeyDark),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.honeyDark),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isUpdating = true);
      
      // Simulate network latency if needed, but AppState is local
      AppState().updateUser(UserData(
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        bio: _bioController.text.trim(),
        school: _schoolController.text.trim(),
        grade: AppState().user.grade,
        subjects: AppState().user.subjects,
        profilePicturePath: _imagePath,
      ));
      
      setState(() => _isUpdating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
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
          title: const Text('Edit Profile', 
            style: TextStyle(color: AppColors.honeyDark, fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.honeyYellow.withValues(alpha: 0.3),
                        backgroundImage: _imagePath != null 
                            ? FileImage(File(_imagePath!)) 
                            : null,
                        child: _imagePath == null 
                            ? const Icon(Icons.person, size: 60, color: AppColors.honeyDark)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showImageSourceSheet,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.honeyDark,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'Full Name',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (v) {
                    final val = v?.trim() ?? '';
                    if (val.isEmpty) return 'Name is required';
                    if (val.length > 30) return 'Max 30 characters';
                    return null;
                  },
                ),
                CustomTextField(
                  label: 'Username',
                  controller: _usernameController,
                  prefixIcon: Icons.alternate_email,
                  validator: (v) {
                    final val = v?.trim() ?? '';
                    if (val.isEmpty) return 'Username is required';
                    if (val.length > 30) return 'Max 30 characters';
                    return null;
                  },
                ),
                CustomTextField(
                  label: 'Bio',
                  controller: _bioController,
                  prefixIcon: Icons.description_outlined,
                  maxLines: 3,
                ),
                CustomTextField(
                  label: 'School',
                  controller: _schoolController,
                  prefixIcon: Icons.school_outlined,
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'Save Changes',
                  isLoading: _isUpdating,
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
