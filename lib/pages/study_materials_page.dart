import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import 'ai_generator_page.dart';
import 'ai_summary_page.dart';

class StudyMaterialsPage extends StatefulWidget {
  final bool embedded;
  const StudyMaterialsPage({super.key, this.embedded = false});

  @override
  State<StudyMaterialsPage> createState() => _StudyMaterialsPageState();
}

class _StudyMaterialsPageState extends State<StudyMaterialsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> _materials = [
    {
      'title': "Newton's Laws.pdf",
      'type': 'PDF',
      'date': 'Feb 2, 2048',
      'pages': '12-14 pages',
      'icon': Icons.picture_as_pdf,
      'color': AppColors.errorRed,
    },
    {
      'title': 'Kinematics_Notes.docx',
      'type': 'DOC',
      'date': 'Jan 15',
      'pages': 'Notes.docx',
      'icon': Icons.description,
      'color': Color(0xFF42A5F5),
    },
    {
      'title': 'Beam_review.pptx',
      'type': 'PPT',
      'date': 'Jan 10',
      'pages': 'PPT',
      'icon': Icons.slideshow,
      'color': AppColors.accentOrange,
    },
    {
      'title': 'Formula_Sheet.jpg',
      'type': 'JPG',
      'date': 'Dec 22, 2049',
      'pages': 'JPG',
      'icon': Icons.image,
      'color': AppColors.successGreen,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = HoneycombBackground(
      showGradient: false,
      child: Column(
        children: [
          if (!widget.embedded)
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: AppColors.honeyDark),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Study Materials',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
          if (!widget.embedded)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search materials...',
                  prefixIcon: Icon(Icons.search, color: AppColors.honeyDark),
                  suffixIcon: Icon(
                    Icons.filter_list,
                    color: AppColors.honeyDark,
                  ),
                  filled: true,
                  fillColor: AppColors.cardWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: AppColors.honeyYellow.withValues(alpha: 0.5),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          if (!widget.embedded)
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: Offset(0, 3),
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
                  indicatorPadding: EdgeInsets.all(6),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  tabs: [
                    Tab(text: 'All'),
                    Tab(text: 'Links'),
                  ],
                ),
              ),
            ),
          Expanded(
            child: widget.embedded
                ? _buildMaterialsList()
                : TabBarView(
                    controller: _tabController,
                    children: [_buildMaterialsList(), _buildLinksTab()],
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AIGeneratorPage()),
              );
            },
            backgroundColor: AppColors.purpleAccent,
            icon: Icon(Icons.auto_awesome, color: Colors.white),
            label: Text(
              'Generate Study Content',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'upload',
            onPressed: () => _showUploadSheet(),
            backgroundColor: AppColors.honeyDark,
            icon: Icon(Icons.upload, color: Colors.white),
            label: Text(
              'Upload Material',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsList() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Recent Materials',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 8),
          ..._materials.map(
            (m) => Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: _buildMaterialCard(m),
            ),
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildMaterialCard(Map<String, dynamic> m) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: (m['color'] as Color).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              m['icon'] as IconData,
              color: m['color'] as Color,
              size: 26,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: (m['color'] as Color).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        m['type'],
                        style: TextStyle(
                          color: m['color'] as Color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.schedule,
                      size: 11,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 3),
                    Text(
                      m['date'],
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AISummaryPage()),
              );
            },
            icon: Icon(
              Icons.visibility,
              color: AppColors.successGreen,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AIGeneratorPage()),
              );
            },
            icon: Icon(
              Icons.auto_awesome,
              color: AppColors.purpleAccent,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete_outline,
              color: AppColors.errorRed,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinksTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 8),
          ...List.generate(
            4,
            (i) => Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.link, color: AppColors.honeyDark),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Physics Reference - Khan Academy',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'khanacademy.org/science/physics',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.open_in_new,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
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
            SizedBox(height: 24),
            Text(
              'Upload Material',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.creamBackground,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.honeyYellow,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload,
                    size: 60,
                    color: AppColors.honeyDark,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Drag & drop your files here',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'or tap to browse',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildUploadChip(
                  'PDF',
                  Icons.picture_as_pdf,
                  AppColors.errorRed,
                ),
                _buildUploadChip(
                  'PPT',
                  Icons.slideshow,
                  AppColors.accentOrange,
                ),
                _buildUploadChip('DOCX', Icons.description, Color(0xFF42A5F5)),
                _buildUploadChip('PNG', Icons.image, AppColors.successGreen),
                _buildUploadChip(
                  'JPG',
                  Icons.image,
                  const Color.fromARGB(255, 236, 22, 255),
                ),
              ],
            ),
            SizedBox(height: 28),
            PrimaryButton(
              text: 'Browse Files',
              icon: Icons.folder_open,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AIGeneratorPage()),
                );
              },
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadChip(String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
