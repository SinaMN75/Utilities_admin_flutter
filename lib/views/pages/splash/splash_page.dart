import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/splash/splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SplashController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) =>
      scaffold(
        appBar: AppBar(title: const Text("Admin")),
        body: const Column(),
      );
}
