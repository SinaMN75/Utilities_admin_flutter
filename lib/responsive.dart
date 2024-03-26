import 'package:utilities/utilities.dart';

class Responsive extends StatelessWidget {
  const Responsive({required this.mobile, this.desktop, final Key? key}) : super(key: key);
  final Widget mobile;
  final Widget? desktop;

  static bool isMobile() => context.width < 500;

  static bool isDesktop() => context.width >= 500;

  @override
  Widget build(final BuildContext context) {
    if (context.width >= 500)
      return desktop ?? mobile;
    else if (context.width >= 500)
      return mobile;
    else
      return mobile;
  }
}
