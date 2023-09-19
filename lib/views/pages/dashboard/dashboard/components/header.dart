import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/responsive.dart';

class Header extends StatelessWidget {
  const Header({
    final Key? key,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) => Row(
        children: <Widget>[
          if (!Responsive.isDesktop(context))
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          if (!Responsive.isMobile(context))
            Text(
              "Dashboard",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          if (!Responsive.isMobile(context)) Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
          const ProfileCard()
        ],
      );
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    final Key? key,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) => Container(
        margin: const EdgeInsets.only(left: 16),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16 / 2,
        ),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: <Widget>[
            if (!Responsive.isMobile(context))
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16 / 2),
                child: Text("Angelina Jolie"),
              ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      );
}
