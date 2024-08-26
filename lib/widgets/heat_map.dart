import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class Heatmap extends StatelessWidget {
  final Map<DateTime, int> datasets;
  final DateTime startDate;
  const Heatmap({
    super.key,
    required this.datasets,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the last day of the current month
    DateTime endDate = DateTime(
      startDate.year,
      startDate.month + 1, // Move to the next month
      0, // Set to the last day of the previous month
    );

    return HeatMap(
      startDate: DateTime(startDate.year, startDate.month, 1), // Start from the 1st day of the month
      endDate: endDate,
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.secondary,
      textColor: Colors.white,
      showColorTip: false,
      showText: true,
      scrollable: false, // Disable scrolling to show the entire month at once
      size: 31,
      colorsets: {
        1: Colors.green.shade50,
        2: Colors.green.shade100,
        3: Colors.green.shade200,
        4: Colors.green.shade300,
        5: Colors.green.shade400,
        6: Colors.green.shade500,
        7: Colors.green.shade600,
        8: Colors.green.shade700,
        9: Colors.green.shade800,
        10: Colors.green.shade900,
      },
    );
  }
}
