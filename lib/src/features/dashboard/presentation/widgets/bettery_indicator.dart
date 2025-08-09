import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class BatteryIndicator extends StatelessWidget {
  final int percentage;
  final double size;

  const BatteryIndicator({
    super.key,
    required this.percentage,
    this.size = 24.0,
  }) : assert(
         percentage >= 0 && percentage <= 100,
         'Percentage must be between 0 and 100',
       );

  @override
  Widget build(BuildContext context) {
    // Determine which icon to use based on percentage
    final IconData icon;
    if (percentage == 0) {
      icon = HugeIcons.strokeRoundedBatteryEmpty;
    } else if (percentage <= 15) {
      icon = HugeIcons.strokeRoundedBatteryLow;
    } else if (percentage <= 50) {
      icon = HugeIcons.strokeRoundedBatteryMedium01;
    } else if (percentage < 100) {
      icon = HugeIcons.strokeRoundedBatteryMedium02;
    } else {
      icon = HugeIcons.strokeRoundedBatteryFull;
    }

    // Determine color based on percentage
    final Color color;
    if (percentage <= 15) {
      color = Colors.red;
    } else if (percentage <= 50) {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }

    return Row(
      spacing: 10,
      children: [
        Icon(icon, color: color, size: size),
        Text("$percentage%"),
      ],
    );
  }
}
