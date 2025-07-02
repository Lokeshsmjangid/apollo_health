import 'package:flutter/material.dart';

class DecoratedJeopardyContainer extends StatelessWidget {
  final Widget child;

  const DecoratedJeopardyContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFF5168C6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // Yellow border with white dots
          Positioned.fill(
            child: CustomPaint(
              painter: DotBorderPainter(),
            ),
          ),
          // Content inside
          child,
        ],
      ),
    );
  }
}

class DotBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintYellow = Paint()
      ..color = Color(0xffFFD93B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    final paintWhite = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(10),
    );

    // Yellow base border
    canvas.drawRRect(rrect, paintYellow);

    // Draw white dots around the border
    const spacing = 10.0;
    const dotRadius = 2.0;

    // Top and bottom dots
    for (double dx = spacing / 2; dx < size.width; dx += spacing) {
      canvas.drawCircle(Offset(dx, 0), dotRadius, paintWhite);
      canvas.drawCircle(Offset(dx, size.height), dotRadius, paintWhite);
    }

    // Left and right dots
    for (double dy = spacing / 2; dy < size.height; dy += spacing) {
      canvas.drawCircle(Offset(0, dy), dotRadius, paintWhite);
      canvas.drawCircle(Offset(size.width, dy), dotRadius, paintWhite);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
