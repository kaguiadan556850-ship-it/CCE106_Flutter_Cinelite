import 'dart:math';
import 'package:flutter/material.dart';

/// Draws a deterministic pseudo-QR pattern seeded from [data] so the
/// same booking always renders the same "code". This stands in for a
/// real QR library (e.g. qrcode.js, as noted in the design doc) since
/// this prototype avoids third-party network dependencies.
class QrPlaceholder extends StatelessWidget {
  final String data;
  final double size;

  const QrPlaceholder({super.key, required this.data, this.size = 140});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'QR code digital ticket for booking reference $data',
      image: true,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _QrPainter(seed: data.hashCode),
        ),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  final int seed;
  _QrPainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    const grid = 14;
    final cell = size.width / grid;
    final rand = Random(seed);
    final paint = Paint()..color = Colors.black;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // Draw random modules
    for (int y = 0; y < grid; y++) {
      for (int x = 0; x < grid; x++) {
        if (_isFinderZone(x, y, grid)) continue;
        if (rand.nextDouble() > 0.55) {
          canvas.drawRect(
            Rect.fromLTWH(x * cell, y * cell, cell, cell),
            paint,
          );
        }
      }
    }

    // Draw the three finder squares (corners), like a real QR code.
    _drawFinder(canvas, 0, 0, cell);
    _drawFinder(canvas, (grid - 3) * cell, 0, cell);
    _drawFinder(canvas, 0, (grid - 3) * cell, cell);
  }

  bool _isFinderZone(int x, int y, int grid) {
    final inTopLeft = x < 4 && y < 4;
    final inTopRight = x >= grid - 4 && y < 4;
    final inBottomLeft = x < 4 && y >= grid - 4;
    return inTopLeft || inTopRight || inBottomLeft;
  }

  void _drawFinder(Canvas canvas, double left, double top, double cell) {
    final outer = Paint()..color = Colors.black;
    final inner = Paint()..color = Colors.white;
    final core = Paint()..color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(left, top, cell * 3, cell * 3), outer);
    canvas.drawRect(
      Rect.fromLTWH(left + cell * 0.5, top + cell * 0.5, cell * 2, cell * 2),
      inner,
    );
    canvas.drawRect(
      Rect.fromLTWH(left + cell, top + cell, cell, cell),
      core,
    );
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) =>
      oldDelegate.seed != seed;
}
