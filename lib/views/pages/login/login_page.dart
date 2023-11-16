import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/login/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  Key? get key => const Key("لاگین");

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoginController {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
        constraints: const BoxConstraints(),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isDesktopSize()) image(Sample.loremPicsum(), fit: BoxFit.cover).expanded(),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                if (isMobileSize() || isTabletSize()) image(Sample.loremPicsum(), fit: BoxFit.cover, height: context.height),
                Card(
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        image(AppImages.logo, width: 100, height: 100).paddingSymmetric(vertical: 8),
                        textField(hintText: "نام کاربری", controller: controllerUserName).paddingSymmetric(vertical: 8),
                        textField(hintText: "رمز عبور", controller: controllerPassword).paddingSymmetric(vertical: 8),
                        button(title: "ورود", onTap: login).paddingSymmetric(vertical: 8),
                      ],
                    ),
                  ).paddingAll(50),
                ).container(padding: EdgeInsets.symmetric(horizontal: context.width / 10), height: 500),
              ],
            ).expanded(),
          ],
        ),
      );
}
