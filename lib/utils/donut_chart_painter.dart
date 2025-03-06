import 'package:flutter/material.dart';
import 'dart:math';

class DonutChart extends StatefulWidget {
  final double size; // 도넛 크기 (사용자가 설정 가능)
  final double strokeWidth;
  final double total;
  final double value;
  final Widget? child;

  const DonutChart({
    super.key,
    required this.size, // 필수 값으로 지정
    this.strokeWidth = 20,
    required this.total,
    required this.value,
    this.child,
  });

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: (widget.value / widget.total) * 100,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox( // 크기를 자동으로 맞춤
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return CustomPaint(
              size: Size(widget.size, widget.size),
              painter: DonutChartPainter(
                strokeWidth: widget.strokeWidth,
                progress: _progressAnimation.value,
              ),
              child: Center(child: widget.child),
            );
          },
        ),
      ),
    );
  }

}

class DonutChartPainter extends CustomPainter {
  final double strokeWidth;
  final double progress;

  DonutChartPainter({required this.strokeWidth, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Color(0xFF888888)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..color = Color(0xFF05FFF7)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = (size.width / 2) - (strokeWidth / 2); // 도넛 크기 조정

    // 배경 원형
    canvas.drawCircle(center, radius, backgroundPaint);

    // 진행된 부분 원형
    double startAngle = -pi / 2;
    double sweepAngle = (progress / 100) * 2 * pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(DonutChartPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
