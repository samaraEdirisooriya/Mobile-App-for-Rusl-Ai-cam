import 'package:flutter/material.dart';
import 'dart:math';

class InteractiveProgressChart extends StatefulWidget {
  const InteractiveProgressChart({super.key});

  @override
  _InteractiveProgressChartState createState() =>
      _InteractiveProgressChartState();
}

class _InteractiveProgressChartState extends State<InteractiveProgressChart>
    with SingleTickerProviderStateMixin {
  double _progress = 0.5; // Initial progress value (180°)
  bool _isAnimating = false;

  void _animateTo(double targetProgress) {
    setState(() {
      _isAnimating = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _progress = targetProgress;
        _isAnimating = false;
      });
    });
  }

  void _handleTap() {
    if (_progress < 1.0) {
      _animateTo(1.0); // Move to 360° (100%) for Indoor mode
    } else {
      _animateTo(0.5); // Return to 180° (50%) for Outdoor mode
    }
  }

  void _handleDragEnd() {
    if (_progress >= 0.60) {
      _animateTo(1.0); // Snap to 360° (100%)
    } else {
      _animateTo(0.5); // Snap back to 180° (50%)
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIndoorMode = _progress >= 1.0;

    return GestureDetector(
      onPanUpdate: (details) {
        if (_isAnimating) return;

        // Calculate new progress based on drag position
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset center = box.size.center(Offset.zero);
        Offset position = details.localPosition - center;

        double angle = atan2(position.dy, position.dx);
        if (angle < 0) angle += 2 * pi;

        setState(() {
          _progress = angle / (2 * pi);
        });
      },
      onPanEnd: (_) {
        _handleDragEnd(); // Handle snapping on drag release
      },
      onTap: _handleTap, // Handle tap action
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: 185,
        height: 185,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circular Progress Indicator with Gradient
            SizedBox(
              width: 160,
              height: 160,
              child: CustomPaint(
                painter: GradientCircularProgressPainter(
                  progress: _progress,
                  gradientColors: isIndoorMode
                      ? [
                          Colors.blue.shade300,
                          Colors.blue.shade600,
                          Colors.blue.shade900,
                        ]
                      : [
                          Colors.brown.shade100,
                          Colors.orange.shade200,
                          Colors.brown.shade400,
                        ],
                ),
              ),
            ),

            // Draggable Dot (Inside the Circle)
            SizedBox(
              width: 250,
              height: 250,
              child: Transform.rotate(
                angle: 2 * pi * _progress,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 24.0), // Bring dot inward
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

            // Center Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.eco,
                  size: 40,
                  color: Colors.white,
                ),
                Text(
                  isIndoorMode ? 'Indoor' : 'Outdoor',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(221, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final List<Color> gradientColors;

  GradientCircularProgressPainter({
    required this.progress,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final sweepAngle = 2 * pi * progress;

    final paint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * pi,
        colors: [
          gradientColors.last,
          ...gradientColors,
          gradientColors.first,
        ],
        stops: [
          0.0,
          ...List.generate(gradientColors.length, (index) => index / gradientColors.length),
          1.0,
        ],
        tileMode: TileMode.clamp,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -pi / 2, // Start from top
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
