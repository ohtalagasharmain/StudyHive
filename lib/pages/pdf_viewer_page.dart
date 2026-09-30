import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../theme/app_theme.dart';

class PdfViewerPage extends StatelessWidget {
  final String title;
  final String path;
  final Uint8List? bytes;
  final bool isUrl;

  const PdfViewerPage({
    super.key,
    required this.title,
    required this.path,
    this.bytes,
    this.isUrl = false,
  });

  bool get _isImage {
    final lower = path.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.gif');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.honeyDark,
        elevation: 1,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isImage) {
      Widget imageWidget;
      if (bytes != null) {
        imageWidget = Image.memory(bytes!, fit: BoxFit.contain);
      } else if (isUrl || path.startsWith('http')) {
        imageWidget = Image.network(
          path,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 64, color: AppColors.honeyDark),
                SizedBox(height: 12),
                Text('Could not load image.'),
              ],
            ),
          ),
        );
      } else {
        imageWidget = Image.file(
          File(path),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 64, color: AppColors.honeyDark),
                SizedBox(height: 12),
                Text('Image Attachment'),
              ],
            ),
          ),
        );
      }
      return InteractiveViewer(
        maxScale: 4.0,
        minScale: 0.8,
        child: Center(child: imageWidget),
      );
    }

    if (bytes != null) {
      return SfPdfViewer.memory(bytes!);
    } else if (isUrl || path.startsWith('http')) {
      return SfPdfViewer.network(path);
    } else {
      return SfPdfViewer.file(File(path));
    }
  }
}
