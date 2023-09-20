import 'package:utilities/utilities.dart';

class Responsive extends StatelessWidget {
  const Responsive({required this.mobile, this.tablet, this.desktop, final Key? key}) : super(key: key);
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  static bool isMobile() => context.width < 850;

  static bool isTablet() => context.width < 1100 && MediaQuery.of(context).size.width >= 850;

  static bool isDesktop() => context.width >= 1100;

  @override
  Widget build(final BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (context.width >= 1100)
      return desktop ?? mobile;
    else if (context.width >= 850)
      return tablet ?? mobile;
    else
      return mobile;
  }
}
