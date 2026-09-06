import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HoneycombBackground extends StatelessWidget {
  final Widget child;
  final bool showHoneycomb;

  const HoneycombBackground({
    super.key,
    required this.child,
    bool showGradient = false,
    this.showHoneycomb = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: showHoneycomb
          ? const Color.fromRGBO(252, 229, 181, 100)
          : AppColors.creamBackground,
      child: Stack(
        children: [
          if (showHoneycomb)
            Positioned.fill(child: CustomPaint(painter: HoneycombPainter())),
          child,
        ],
      ),
    );
  }
}

class HoneycombPainter extends CustomPainter {
  static const double _radius = 42.0;
  static const double _strokeWidth = 3.5;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    final tileWidth = sqrt(3) * _radius;
    final rowHeight = 1.5 * _radius;
    final maxColumns = (size.width / tileWidth).ceil();
    final maxRows = (size.height / rowHeight).ceil();

    for (int row = -1; row <= maxRows + 2; row++) {
      final y = row * rowHeight;
      final xOffset = row.isOdd ? tileWidth / 2 : 0.0;
      for (int column = -1; column <= maxColumns + 2; column++) {
        final x = column * tileWidth + xOffset;
        _drawHexagon(canvas, Offset(x, y), paint);
      }
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = -pi / 2 + i * pi / 3;
      final x = center.dx + _radius * cos(angle);
      final y = center.dy + _radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
