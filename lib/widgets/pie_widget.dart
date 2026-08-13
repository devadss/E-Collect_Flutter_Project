import 'package:flutter/material.dart';
import 'dart:math';
import 'pie_chart_data.dart';

/// Main pie chart widget with animation
class AnimatedPieChart extends StatefulWidget {
  final PieChartData data;
  final Duration animationDuration;
  final double explodeDistance;
  final bool showCenterText;
  final ValueChanged<int>? onSegmentSelected;

  const AnimatedPieChart({
    super.key,
    required this.data,
    this.animationDuration = const Duration(seconds: 1),
    this.explodeDistance = 0.08,
    this.showCenterText = true,
    this.onSegmentSelected,
  });

  @override
  State<AnimatedPieChart> createState() => _AnimatedPieChartState();
}

class _AnimatedPieChartState extends State<AnimatedPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _selectedIndex = -1;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth < 400
            ? constraints.maxWidth * 0.7
            : constraints.maxWidth * 0.45;
        return Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(size, size),
                painter: PieChartPainter(
                  segments: widget.data.segments,
                  total: widget.data.total,
                  selectedIndex: _selectedIndex,
                  animationValue: _controller.value,
                  explodeDistance: widget.explodeDistance,
                  showCenterText: widget.showCenterText,
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Method to update selection from parent
  void selectSegment(int index) {
    setState(() {
      _selectedIndex = _selectedIndex == index ? -1 : index;
      widget.onSegmentSelected?.call(_selectedIndex);
    });
  }
}

/// Legend widget for the pie chart
class PieChartLegend extends StatelessWidget {
  final PieChartData data;
  final int selectedIndex;
  final ValueChanged<int> onSegmentTapped;

  const PieChartLegend({
    super.key,
    required this.data,
    required this.selectedIndex,
    required this.onSegmentTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 12),
          child: Text(
            'Revenue Distribution',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: data.segments.length,
            itemBuilder: (context, index) {
              final segment = data.segments[index];
              final isSelected = selectedIndex == index;
              final percentage = (segment.value / data.total * 100);

              return MouseRegion(
                onEnter: (_) => onSegmentTapped(index),
                onExit: (_) => onSegmentTapped(-1),
                child: GestureDetector(
                  onTap: () => onSegmentTapped(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? segment.color.withValues(alpha: 0.3)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? Border.all(color: segment.color, width: 2)
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: segment.color,
                            shape: BoxShape.circle,
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: segment.color.withValues(alpha: 0.5),
                                blurRadius: 8,
                              )
                            ]
                                : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            segment.label,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.6),
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.6),
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Custom painter for the pie chart
class PieChartPainter extends CustomPainter {
  final List<PieChartSegment> segments;
  final double total;
  final int selectedIndex;
  final double animationValue;
  final double explodeDistance;
  final bool showCenterText;

  PieChartPainter({
    required this.segments,
    required this.total,
    required this.selectedIndex,
    required this.animationValue,
    this.explodeDistance = 0.08,
    this.showCenterText = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (total == 0 || segments.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    double startAngle = -pi / 2;

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final sweepAngle = (segment.value / total) * 2 * pi * animationValue;
      final isSelected = i == selectedIndex;

      final path = Path();
      if (isSelected) {
        // Explode effect
        final explodeDist = radius * explodeDistance;
        final midAngle = startAngle + sweepAngle / 2;
        final offsetX = explodeDist * cos(midAngle);
        final offsetY = explodeDist * sin(midAngle);
        final newCenter = center + Offset(offsetX, offsetY);

        path.moveTo(newCenter.dx, newCenter.dy);
        path.arcTo(
          Rect.fromCircle(center: newCenter, radius: radius),
          startAngle,
          sweepAngle,
          false,
        );
        path.close();

        // Draw glow
        final glowPaint = Paint()
          ..color = segment.color.withValues(alpha: 0.15)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
        canvas.drawPath(path, glowPaint);

        // Draw slice with gradient
        final paint = Paint()
          ..shader = SweepGradient(
            colors: [
              segment.color.withValues(alpha: 0.9),
              segment.color,
            ],
            startAngle: startAngle,
            endAngle: startAngle + sweepAngle,
          ).createShader(Rect.fromCircle(center: newCenter, radius: radius))
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
        canvas.drawPath(path, paint);

        // Border stroke
        final borderPaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawPath(path, borderPaint);
      } else {
        path.moveTo(center.dx, center.dy);
        path.arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
        );
        path.close();

        // Draw slice
        final paint = Paint()
          ..shader = SweepGradient(
            colors: [
              segment.color.withValues(alpha: 0.7),
              segment.color,
            ],
            startAngle: startAngle,
            endAngle: startAngle + sweepAngle,
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
        canvas.drawPath(path, paint);

        // Subtle border
        final borderPaint = Paint()
          ..color = Colors.black.withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
        canvas.drawPath(path, borderPaint);
      }

      _drawLabel(
        canvas,
        center,
        radius,
        startAngle,
        sweepAngle,
        segment,
        total,
        isSelected,
      );

      startAngle += sweepAngle;
    }

    // Center circle for donut effect
    final donutPaint = Paint()
      ..color = const Color(0xFF0D1117)
      ..style = PaintingStyle.fill;
    final donutRadius = radius * 0.45;
    canvas.drawCircle(center, donutRadius, donutPaint);

    // Center text
    if (showCenterText) {
      _drawCenterText(canvas, center, radius, total);
    }
  }

  void _drawLabel(
      Canvas canvas,
      Offset center,
      double radius,
      double startAngle,
      double sweepAngle,
      PieChartSegment segment,
      double total,
      bool isSelected,
      ) {
    final midAngle = startAngle + sweepAngle / 2;
    final labelRadius = radius * 0.75;
    final x = center.dx + labelRadius * cos(midAngle);
    final y = center.dy + labelRadius * sin(midAngle);

    final percentage = (segment.value / total * 100);
    if (percentage < 5) return;

    final textSpan = TextSpan(
      text: '${percentage.toStringAsFixed(0)}%',
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9),
        fontSize: radius * 0.12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final textOffset = Offset(
      x - textPainter.width / 2,
      y - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  void _drawCenterText(Canvas canvas, Offset center, double radius, double total) {
    final textSpan = TextSpan(
      text: '${total.toStringAsFixed(0)}%',
      style: TextStyle(
        color: Colors.white,
        fontSize: radius * 0.35,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant PieChartPainter oldDelegate) {
    return oldDelegate.segments != segments ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.animationValue != animationValue;
  }
}