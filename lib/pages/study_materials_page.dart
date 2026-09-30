import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import 'pdf_viewer_page.dart';
import '../services/app_state.dart';

class StudyMaterialsPage extends StatefulWidget {
  final bool embedded;
  final String hiveId;
  final String hiveName;

  const StudyMaterialsPage({
    super.key,
    this.embedded = false,
    this.hiveId = 'physics-hive',
    this.hiveName = 'Physics Hive',
  });

  @override
  State<StudyMaterialsPage> createState() => _StudyMaterialsPageState();
}

class _StudyMaterialsPageState extends State<StudyMaterialsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  bool _isUploading = false;
  List<StudyMaterial> _backendMaterials = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadHiveMaterials();
  }

  Future<void> _loadHiveMaterials() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://localhost:8080/resources/hive/${widget.hiveId}',
        ),
      );

      if (response.statusCode != 200) {
        debugPrint(
          'Failed to load materials: ${response.statusCode}',
        );
        return;
      }

      final List<dynamic> resources = jsonDecode(response.body);

      debugPrint(
        'Loaded ${resources.length} materials for Hive ${widget.hiveId}',
      );

      _backendMaterials.clear();

      for (final resource in resources) {
        final type = resource['type'] == 'link'
            ? StudyMaterialType.link
            : _getMaterialType(
          (resource['title'] as String).split('.').last,
        );

        _backendMaterials.add(
          StudyMaterial(
            id: resource['id'],
            title: resource['title'],
            type: type,
            date: resource['date'],
            path: 'http://localhost:8080${resource['path']}',
            icon: _getIconForType(type),
            color: _getColorForType(type),         ),
        );
      }

      if (mounted) {
        setState(() {});
      }

    } catch (e) {
      debugPrint('Error loading hive materials: $e');
    }
  }


  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _uploadMaterial() async {
    setState(() => _isUploading = true);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        withData: true,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'png',
          'jpg',
          'jpeg',
          'ppt',
          'pptx',
        ],
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        if (file.bytes == null) {
          throw Exception('Could not read the selected file.');
        }

        final type = _getMaterialType(file.extension);
        final color = _getColorForType(type);
        final icon = _getIconForType(type);

        final response = await http.post(
          Uri.parse('http://localhost:8080/resources/upload'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'title': file.name,
            'type': type.name,
            'date': 'Just now',
            'userId': '1',
            'hiveId': widget.hiveId,
            'fileBase64': base64Encode(file.bytes!),
          }),
        );

        if (response.statusCode != 200) {
          throw Exception(
            'Server upload failed: ${response.statusCode}',
          );
        }

        final data = jsonDecode(response.body);
        final resource = data['resource'];

        final newMaterial = StudyMaterial(
          id: resource['id'],
          title: resource['title'],
          type: type,
          date: resource['date'],
          path: 'http://localhost:8080${resource['path']}',
          bytes: file.bytes,
          icon: icon,
          color: color,
        );

        AppState().addMaterial(widget.hiveId, newMaterial);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${file.name} uploaded successfully!'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _addLink() async {
    final titleController = TextEditingController();
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(labelText: 'URL (https://...)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
    onPressed: () async {
    if (titleController.text.isNotEmpty &&
    urlController.text.isNotEmpty) {
    try {
    final response = await http.post(
    Uri.parse('http://localhost:8080/resources/'),
    headers: {
    'Content-Type': 'application/json',
    },
    body: jsonEncode({
    'title': titleController.text,
    'type': 'link',
    'date': 'Just now',
    'path': urlController.text,
    'userId': '1',
    'hiveId': widget.hiveId,
    }),
    );

    if (response.statusCode != 200) {
    throw Exception(
    'Failed to save link: ${response.statusCode}',
    );
    }

    final data = jsonDecode(response.body);
    final resource = data['resource'];

    final newLink = StudyMaterial(
    id: resource['id'],
    title: resource['title'],
    type: StudyMaterialType.link,
    date: resource['date'],
    path: resource['path'],
    icon: Icons.link,
    color: AppColors.honeyDark,
    );

    AppState().addMaterial(widget.hiveId, newLink);

    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    content: Text('Link added successfully!'),
    ),
    );
    } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Error adding link: $e'),
    ),
    );
    }
    }
    },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  StudyMaterialType _getMaterialType(String? ext) {
    if (ext == null) return StudyMaterialType.doc;
    switch (ext.toLowerCase()) {
      case 'pdf': return StudyMaterialType.pdf;
      case 'doc':
      case 'docx': return StudyMaterialType.doc;
      case 'ppt':
      case 'pptx': return StudyMaterialType.ppt;
      case 'png':
      case 'jpg':
      case 'jpeg': return StudyMaterialType.image;
      default: return StudyMaterialType.doc;
    }
  }

  Color _getColorForType(StudyMaterialType type) {
    switch (type) {
      case StudyMaterialType.pdf: return AppColors.errorRed;
      case StudyMaterialType.doc: return const Color(0xFF42A5F5);
      case StudyMaterialType.ppt: return AppColors.accentOrange;
      case StudyMaterialType.image: return AppColors.successGreen;
      case StudyMaterialType.link: return AppColors.honeyDark;
    }
  }

  IconData _getIconForType(StudyMaterialType type) {
    switch (type) {
      case StudyMaterialType.pdf: return Icons.picture_as_pdf;
      case StudyMaterialType.doc: return Icons.description;
      case StudyMaterialType.ppt: return Icons.slideshow;
      case StudyMaterialType.image: return Icons.image;
      case StudyMaterialType.link: return Icons.link;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final hive = AppState().hives.firstWhere((h) => h.id == widget.hiveId, 
          orElse: () => HiveData(id: widget.hiveId, name: widget.hiveName, subject: ''));

        final allMaterials = [
          ...hive.materials,
          ..._backendMaterials,
        ];

        final materials = allMaterials.where((m) =>
        m.type != StudyMaterialType.link &&
            m.title.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            )
        ).toList();

        final links = allMaterials.where((m) =>
        m.type == StudyMaterialType.link &&
            m.title.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ),
        ).toList();


        final body = HoneycombBackground(
          showGradient: false,
          child: Column(
            children: [
              if (!widget.embedded)
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: AppColors.honeyDark),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Study Materials',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              if (!widget.embedded)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search materials...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.honeyDark),
                      suffixIcon: const Icon(Icons.filter_list, color: AppColors.honeyDark),
                      filled: true,
                      fillColor: AppColors.cardWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: AppColors.honeyYellow.withValues(alpha: 0.5),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              if (!widget.embedded)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: AppColors.honeyDark,
                      unselectedLabelColor: AppColors.textSecondary,
                      indicator: BoxDecoration(
                        color: AppColors.honeyYellow.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      indicatorPadding: const EdgeInsets.all(6),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Links'),
                      ],
                    ),
                  ),
                ),
              if (_isUploading)
                const LinearProgressIndicator(color: AppColors.honeyDark),
              Expanded(
                child: widget.embedded
                    ? _buildMaterialsList(materials)
                    : TabBarView(
                        controller: _tabController,
                        children: [_buildMaterialsList(materials), _buildLinksTab(links)],
                      ),
              ),
            ],
          ),
        );

        if (widget.embedded) return body;
        
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(child: body),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.extended(
                heroTag: 'link',
                onPressed: _addLink,
                backgroundColor: AppColors.accentOrange,
                icon: const Icon(Icons.link, color: Colors.white),
                label: const Text(
                  'Add Link',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              const SizedBox(height: 12),
              FloatingActionButton.extended(
                heroTag: 'upload',
                onPressed: () => _showUploadSheet(),
                backgroundColor: AppColors.honeyDark,
                icon: const Icon(Icons.upload, color: Colors.white),
                label: const Text(
                  'Upload Material',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMaterialsList(List<StudyMaterial> materials) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Recent Materials',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 8),
          if (materials.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text('No materials found.'),
              ),
            ),
          ...materials.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildMaterialCard(m),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildMaterialCard(StudyMaterial m) {
    return InkWell(
      onTap: () {
        if (m.type == StudyMaterialType.pdf && m.path.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PdfViewerPage(
                title: m.title,
                path: m.path,
                bytes: m.bytes,
                isUrl: m.path.startsWith('http'),
              ),
            ),
          );
        } else if (m.type == StudyMaterialType.image && m.path.isNotEmpty) {
          showDialog(
            context: context,
            builder: (_) => Dialog(
              child: InteractiveViewer(
                child: Image.network(
                  m.path,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        } else if (m.type == StudyMaterialType.link) {
          launchUrl(Uri.parse(m.path));
        } else {
          if (m.path.isNotEmpty) {
            launchUrl(
              Uri.parse(m.path),
              mode: LaunchMode.externalApplication,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('File not available: ${m.title}'),
              ),
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
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
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: m.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                m.icon,
                color: m.color,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: m.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          m.type.name.toUpperCase(),
                          style: TextStyle(
                            color: m.color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.schedule,
                        size: 11,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          m.date,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 32,
              height: 32,
              child: IconButton(
                onPressed: () {
                  AppState().saveResource(m);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Saved to resources!'),
                    ),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 32,
                  height: 32,
                ),
                icon: const Icon(
                  Icons.bookmark_border,
                  color: AppColors.honeyDark,
                  size: 20,
                ),
              ),
            ),
            SizedBox(
              width: 32,
              height: 32,
              child: IconButton(
                onPressed: () async {
                  await AppState().deleteMaterial(
                    widget.hiveId,
                    m.id,
                  );

                  if (!mounted) return;

                  setState(() {
                    _backendMaterials.removeWhere(
                          (material) => material.id == m.id,
                    );
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 32,
                  height: 32,
                ),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.errorRed,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinksTab(List<StudyMaterial> links) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          if (links.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text('No links added yet.'),
              ),
            ),
          ...links.map((link) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildMaterialCard(link),
          )),
        ],
      ),
    );
  }

  void _showUploadSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.honeyCombLine,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Upload Material',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _uploadMaterial();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppColors.creamBackground,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.honeyYellow,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: 60,
                      color: AppColors.honeyDark,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tap to browse files',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'PDF, PPTX, DOCX, Images',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              text: 'Close',
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
