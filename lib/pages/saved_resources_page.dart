import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../services/app_state.dart';
import 'pdf_viewer_page.dart';

class SavedResourcesPage extends StatelessWidget {
  const SavedResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final resources = AppState().savedResources;

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
              title: const Text('Saved Resources', 
                style: TextStyle(color: AppColors.honeyDark, fontWeight: FontWeight.bold)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.sync, color: AppColors.honeyDark),
                  tooltip: 'Sync Resources',
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Syncing resources with server...')),
                    );
                    await AppState().saveResourcesToStorageAndServer();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Resources successfully synchronized!')),
                      );
                    }
                  },
                ),
              ],
            ),
            body: resources.isEmpty
                ? const Center(
                    child: Text(
                      'No saved resources yet.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: resources.length,
                    itemBuilder: (context, index) {
                      final m = resources[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.cardWhite,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: m.color.withValues(alpha: 0.15),
                                    radius: 22,
                                    child: Icon(m.icon, color: m.color, size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          m.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: AppColors.textPrimary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            _buildBadge(
                                              m.type.name.toUpperCase(),
                                              m.color.withValues(alpha: 0.15),
                                              m.color,
                                            ),
                                            const SizedBox(width: 6),
                                            _buildBadge(
                                              m.rarity.toUpperCase(),
                                              AppColors.honeyYellow.withValues(alpha: 0.25),
                                              AppColors.honeyDark,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
                                    onPressed: () {
                                      AppState().removeSavedResource(m.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${m.title} removed.')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Divider(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quantity: ${m.quantity} / ${m.quantityCap}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Bonus: +${(m.bonus * 100).toInt()}% | Multiplier: ${m.multiplier}x',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, size: 20),
                                        color: AppColors.honeyDark,
                                        onPressed: m.quantity > 0
                                            ? () => AppState().updateResourceQuantity(m.id, m.quantity - 1)
                                            : null,
                                      ),
                                      Text(
                                        '${m.quantity}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline, size: 20),
                                        color: AppColors.honeyDark,
                                        onPressed: m.quantity < m.quantityCap
                                            ? () => AppState().updateResourceQuantity(m.id, m.quantity + 1)
                                            : null,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    if ((m.type == StudyMaterialType.pdf || m.type == StudyMaterialType.image) && m.path.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PdfViewerPage(
                                            title: m.title,
                                            path: m.path,
                                            isUrl: m.path.startsWith('http'),
                                          ),
                                        ),
                                      );
                                    } else if (m.type == StudyMaterialType.link) {
                                      launchUrl(Uri.parse(m.path));
                                    }
                                  },
                                  icon: const Icon(Icons.open_in_new, size: 16),
                                  label: const Text('Open Resource'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.honeyDark,
                                    side: BorderSide(
                                      color: AppColors.honeyYellow.withValues(alpha: 0.6),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _buildBadge(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
