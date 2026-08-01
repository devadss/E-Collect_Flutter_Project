import 'dart:math';

import 'package:flutter/material.dart';

/// Data model for a pie chart segment
class PieChartSegment {
  final String label;
  final double value;
  final Color color;

  PieChartSegment({
    required this.label,
    required this.value,
    required this.color,
  });
}

/// Data class containing all pie chart configuration
class PieChartData {
  final List<PieChartSegment> segments;
  final double totalValue;

  const PieChartData({
    required this.segments,
    this.totalValue = 0,
  });

  // Get total value if not provided
  double get total => totalValue > 0
      ? totalValue
      : segments.fold(0, (sum, segment) => sum + segment.value);

  // Factory method to create default data
  factory PieChartData.defaultData() {
    const colors = [
      Color(0xFF6C63FF),
      Color(0xFFFF6584),
      Color(0xFFFFB347),
      Color(0xFF00D2FF),
      Color(0xFF7B61FF),
      Color(0xFFFF6B6B),
    ];

    final labels = [
      'Design',
      'Development',
      'Marketing',
      'Sales',
      'Support',
      'Other',
    ];

    final values = [35.0, 25.0, 20.0, 10.0, 7.0, 3.0];

    return PieChartData(
      segments: List.generate(
        labels.length,
            (index) => PieChartSegment(
          label: labels[index],
          value: values[index],
          color: colors[index % colors.length],
        ),
      ),
    );
  }

  // Method to generate random data
  factory PieChartData.random() {
    const colors = [
      Color(0xFF6C63FF),
      Color(0xFFFF6584),
      Color(0xFFFFB347),
      Color(0xFF00D2FF),
      Color(0xFF7B61FF),
      Color(0xFFFF6B6B),
    ];

    final labels = [
      'Design',
      'Development',
      'Marketing',
      'Sales',
      'Support',
      'Other',
    ];

    final random = Random();
    final values = List.generate(
      labels.length,
          (index) => random.nextDouble() * 25 + 5,
    );

    return PieChartData(
      segments: List.generate(
        labels.length,
            (index) => PieChartSegment(
          label: labels[index],
          value: values[index],
          color: colors[index % colors.length],
        ),
      ),
    );
  }
}