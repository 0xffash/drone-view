import 'package:hugeicons/hugeicons.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class WifiSignalWithPing extends StatelessWidget {
  final int ping;

  const WifiSignalWithPing({super.key, required this.ping});

  @override
  Widget build(BuildContext context) {
    // Determine icon and color based on ping value
    IconData icon;
    Color color;

    if (ping <= 80) {
      icon = HugeIcons.strokeRoundedWifiFullSignal;
      color = Colors.green;
    } else if (ping <= 100) {
      icon = HugeIcons.strokeRoundedWifiMediumSignal;
      color = Colors.orange;
    } else if (ping > 100) {
      icon = HugeIcons.strokeRoundedWifiLowSignal;
      color = Colors.red;
    } else {
      // Fallback for invalid/negative values
      icon = HugeIcons.strokeRoundedWifiNoSignal;
      color = Colors.gray;
    }

    return Row(
      spacing: 10,
      children: [
        Icon(icon, color: color),
        Text("${ping}ms"),
      ],
    );
  }
}
