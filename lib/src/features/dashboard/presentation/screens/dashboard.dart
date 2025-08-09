import 'package:atheer/src/app/constants/app_constants.dart';
import 'package:atheer/src/features/dashboard/presentation/widgets/action_card.dart';
import 'package:atheer/src/features/dashboard/presentation/widgets/drone_view.dart';
import 'package:atheer/src/features/dashboard/presentation/widgets/mini_map.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool full_screen = false;
  bool expanded = false;
  int selected = 0;

  NavigationItem buildButton(String text, IconData icon) {
    return NavigationItem(
      label: Text(text),
      alignment: Alignment.centerLeft,
      selectedStyle: const ButtonStyle.primaryIcon(),
      child: Icon(icon),
    );
  }

  NavigationLabel buildLabel(String label) {
    return NavigationLabel(
      alignment: Alignment.centerLeft,
      child: Text(label).semiBold().muted(),
      // padding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: OutlinedContainer(
        child: Row(
          children: [
            NavigationRail(
              backgroundColor: Theme.of(context).colorScheme.card,
              labelType: NavigationLabelType.expanded,
              labelPosition: NavigationLabelPosition.end,
              alignment: NavigationRailAlignment.start,
              expanded: expanded,
              index: selected,
              onSelected: (value) {
                setState(() {
                  selected = value;
                });
              },
              children: [
                NavigationButton(
                  alignment: Alignment.centerLeft,
                  label: const Text('Menu'),
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  child: const Icon(Icons.menu),
                ),
                const NavigationDivider(),
                buildLabel('You'),
                buildButton('Home', Icons.home_filled),
              ],
            ),
            const VerticalDivider(),
            if (full_screen == false)
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 15,
                    children: [
                      MiniMap(),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(
                            AppConstants.defaultPadding,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.border,
                            ),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              spacing: 20,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    infomethod(
                                      context,
                                      "السرعة",
                                      "10/كم",
                                      HugeIcons.strokeRoundedRocket01,
                                    ),
                                    infomethod(
                                      context,
                                      "الارتفاع",
                                      "12/م",
                                      HugeIcons.strokeRoundedArrowUp05,
                                    ),
                                    infomethod(
                                      context,
                                      "وقت الطيران",
                                      "10",
                                      HugeIcons.strokeRoundedTime04,
                                    ),

                                    infomethod(
                                      context,
                                      "قوة الإشارة",
                                      "10ms",
                                      HugeIcons.strokeRoundedConnect,
                                    ),
                                  ],
                                ),
                                VerticalDivider(),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    infomethod(
                                      context,
                                      "خط الطول",
                                      "10",
                                      HugeIcons.strokeRoundedLocation01,
                                    ),
                                    infomethod(
                                      context,
                                      "التسارع",
                                      "10",
                                      HugeIcons.strokeRoundedAcceleration,
                                    ),
                                    infomethod(
                                      context,
                                      "الاقمار الصناعية",
                                      "10",
                                      HugeIcons.strokeRoundedSatellite02,
                                    ),
                                    infomethod(
                                      context,
                                      "وضع الطيران",
                                      "10",
                                      HugeIcons.strokeRoundedDrone,
                                    ),
                                  ],
                                ),
                                VerticalDivider(),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    infomethod(
                                      context,
                                      "نسبة البطارية",
                                      "10%",
                                      HugeIcons.strokeRoundedBatteryFull,
                                    ),
                                    infomethod(
                                      context,
                                      "جهد البطارية",
                                      "10v",
                                      HugeIcons
                                          .strokeRoundedAutomotiveBattery02,
                                    ),
                                    infomethod(
                                      context,
                                      "اتجاه",
                                      "10",
                                      HugeIcons.strokeRoundedCompass,
                                    ),
                                    infomethod(
                                      context,
                                      "المسافة المنقطعة",
                                      "10/م",
                                      HugeIcons.strokeRoundedHome10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  Expanded(
                    child: DroneView(
                      fullScreen: () {
                        setState(() {
                          full_screen = !full_screen;
                        });
                      },
                    ),
                  ),
                  if (full_screen == false)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultPadding,
                      ),
                      child: Row(
                        spacing: 15,
                        children: [
                          Expanded(
                            child: ActionCard(
                              actionText: "غير مفعلة",
                              labelText: "التعرف على الهدف",
                              onPressed: () {},
                              icon: HugeIcons.strokeRoundedUser,
                            ),
                          ),
                          Expanded(
                            child: ActionCard(
                              actionText: "غير مفعلة",
                              labelText: "تصوير",
                              onPressed: () {},
                              icon: HugeIcons.strokeRoundedCameraVideo,
                            ),
                          ),
                          Expanded(
                            child: ActionCard(
                              actionText: "test",
                              labelText: "test",
                              onPressed: () {},
                              icon: Icons.abc,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column infomethod(BuildContext context, title, text, icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          spacing: 5,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.mutedForeground),
            Text(title).xLarge.muted,
          ],
        ),
        Text(text).x3Large.bold,
      ],
    );
  }
}
