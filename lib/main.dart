import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/generated/l10n.dart';
import 'package:utilities_admin_flutter/views/pages/splash/splash_page.dart';

Future<void> main() async {
  initUtilities();

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.dualRing
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.transparent
    ..maskColor = Colors.blue
    ..maskType = EasyLoadingMaskType.clear
    ..indicatorWidget = const CircularProgressIndicator()
    ..loadingStyle = EasyLoadingStyle.custom
    ..userInteractions = false
    ..boxShadow = <BoxShadow>[]
    ..dismissOnTap = false;

  runApp(const App());
}

class App extends StatefulWidget {
  const App({final Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(final BuildContext context) => GetMaterialApp(
        enableLog: false,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          S.delegate,
        ],
        supportedLocales: const <Locale>[Locale("fa")],
        locale: const Locale("fa"),
        textDirection: TextDirection.rtl,
        theme: AppThemes.light,
        themeMode: ThemeMode.light,
        home: const SplashPage(),
        builder: EasyLoading.init(),
      );
}
