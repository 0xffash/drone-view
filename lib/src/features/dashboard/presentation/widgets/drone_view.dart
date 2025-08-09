import 'package:atheer/src/app/constants/app_constants.dart';
import 'package:atheer/src/features/dashboard/presentation/widgets/CompassIndicator.dart';
import 'package:atheer/src/features/dashboard/presentation/widgets/bettery_indicator.dart';
import 'package:atheer/src/features/dashboard/presentation/widgets/ping_indicator.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class DroneView extends StatefulWidget {
  final VoidCallback fullScreen;
  const DroneView({super.key, required this.fullScreen});

  @override
  State<DroneView> createState() => _DroneViewState();
}

class _DroneViewState extends State<DroneView> {
  bool _showFullScreenIcon = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black,
          ),

          child: MouseRegion(
            onHover: (event) => setState(() => _showFullScreenIcon = true),
            onExit: (event) => setState(() => _showFullScreenIcon = false),
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  right: 16,
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 200,
                    color: Colors.white, // Turns black parts to white
                    colorBlendMode:
                        BlendMode.srcIn, // Applies color to the image
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Column(
                    children: [
                      WifiSignalWithPing(ping: 85),
                      Row(
                        spacing: 10,
                        children: [BatteryIndicator(percentage: 73)],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 100,
                  right: 16,
                  child: Column(
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Column(
                            children: [
                              Text("100").x2Large,
                              Text("ارتفاع/م").medium.muted,
                            ],
                          ),

                          Icon(HugeIcons.strokeRoundedStartUp01, size: 30),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 180,
                  right: 16,
                  child: Column(
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Column(
                            children: [
                              Text("23").x2Large,
                              Text("كم/س").medium.muted,
                            ],
                          ),

                          Icon(
                            HugeIcons.strokeRoundedDashboardSpeed02,
                            size: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Column(
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Icon(HugeIcons.strokeRoundedLocation08, size: 24),
                          Column(
                            children: [
                              Text("51.20").large,
                              Text("خط الطول").muted,
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 75,
                  left: 16,
                  child: Column(
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Icon(HugeIcons.strokeRoundedLocation08, size: 24),
                          Column(
                            children: [
                              Text("-251.20").large,
                              Text("خط العرض").muted,
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 50,
                  right: 16,
                  child: Column(
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Text("01:30").muted.large,
                          Icon(
                            HugeIcons.strokeRoundedLiveStreaming02,
                            size: 24,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Column(
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Text("مدة الطيران").medium.muted,

                          Text("10:52").x2Large,
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      // Show if not initialized, not playing, or has error
                      padding: EdgeInsets.all(AppConstants.defaultPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(
                          context,
                        ).colorScheme.destructive.withOpacity(0.2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 20,
                        children: [
                          Text(
                            "لا يوجد اتصال",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.destructive,
                            ),
                          ).x5Large,
                          Icon(
                            HugeIcons.strokeRoundedAlert02,
                            color: Theme.of(context).colorScheme.destructive,
                            size: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      CompassIndicator(width: 200, initialDegree: 270),
                    ],
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: _showFullScreenIcon ? 1.0 : 0.0,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            widget.fullScreen();
                          },
                          icon: Icon(HugeIcons.strokeRoundedFullScreen),
                          variance: ButtonVariance.outline,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
