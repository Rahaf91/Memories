import 'package:flutter/material.dart';

import '../../models/mood.dart';

/// Minimal line-drawn facial expression for a [Mood]: two eyes and a
/// mouth, no fill. Draw it inside a circular container, or set
/// [showOutline] to draw the face circle too.
class MoodFace extends StatelessWidget {
  const MoodFace({
    super.key,
    required this.mood,
    required this.color,
    this.size = 24,
    this.showOutline = false,
  });

  final Mood mood;
  final Color color;
  final double size;
  final bool showOutline;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _MoodFacePainter(
          mood: mood,
          color: color,
          showOutline: showOutline,
        ),
      ),
    );
  }
}

class _MoodFacePainter extends CustomPainter {
  _MoodFacePainter({
    required this.mood,
    required this.color,
    required this.showOutline,
  });

  final Mood mood;
  final Color color;
  final bool showOutline;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final c = size.center(Offset.zero);
    final stroke = s * 0.075;
    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = color;

    // Points are expressed relative to the center, in units of size.
    Offset p(double x, double y) => c + Offset(x * s, y * s);

    if (showOutline) {
      canvas.drawCircle(c, s / 2 - stroke / 2, line);
    }

    // Eyes: softly arched for "Happy" (Mood.amazing), dots otherwise.
    final eyeY = mood == Mood.veryBad ? -0.06 : -0.1;
    if (mood == Mood.amazing) {
      for (final x in const [-0.17, 0.17]) {
        final eye = Path()
          ..moveTo(p(x - 0.07, eyeY + 0.02).dx, p(x - 0.07, eyeY + 0.02).dy)
          ..quadraticBezierTo(
            p(x, eyeY - 0.07).dx,
            p(x, eyeY - 0.07).dy,
            p(x + 0.07, eyeY + 0.02).dx,
            p(x + 0.07, eyeY + 0.02).dy,
          );
        canvas.drawPath(eye, line);
      }
    } else {
      canvas.drawCircle(p(-0.17, eyeY), stroke * 0.85, fill);
      canvas.drawCircle(p(0.17, eyeY), stroke * 0.85, fill);
    }

    // Brows, only for "Very Bad": angled inward for a tense look.
    if (mood == Mood.veryBad) {
      canvas.drawLine(p(-0.27, -0.25), p(-0.1, -0.18), line);
      canvas.drawLine(p(0.27, -0.25), p(0.1, -0.18), line);
    }

    // Mouth: a quadratic curve; control point sets the smile/frown.
    final (double half, double y, double bend) = switch (mood) {
      Mood.amazing => (0.21, 0.1, 0.26),
      Mood.good => (0.16, 0.14, 0.14),
      Mood.okay => (0.15, 0.18, 0.0),
      Mood.sad => (0.15, 0.22, -0.11),
      Mood.veryBad => (0.17, 0.24, -0.17),
    };
    if (bend == 0) {
      canvas.drawLine(p(-half, y), p(half, y), line);
    } else {
      final mouth = Path()
        ..moveTo(p(-half, y).dx, p(-half, y).dy)
        ..quadraticBezierTo(
          p(0, y + bend).dx,
          p(0, y + bend).dy,
          p(half, y).dx,
          p(half, y).dy,
        );
      // "Happy" (Mood.amazing) gets an open smile: the curve closed by a
      // flat top.
      if (mood == Mood.amazing) mouth.close();
      canvas.drawPath(mouth, line);
    }
  }

  @override
  bool shouldRepaint(_MoodFacePainter old) =>
      old.mood != mood || old.color != color || old.showOutline != showOutline;
}
