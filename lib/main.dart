import 'package:atheer/src/app/routes/app_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  VideoPlayerMediaKit.ensureInitialized(
    windows:
        true, // default: false    -    dependency: media_kit_libs_windows_video
    linux: true, // default: false    -    dependency: media_kit_libs_linux
  );
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: Locale('ar'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: Locale('ar'),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        typography: Typography.geist(sans: TextStyle(fontFamily: "Zain")),
        colorScheme: ColorSchemes.darkZinc(),
        radius: 0.5,
      ),
    );
  }
}
