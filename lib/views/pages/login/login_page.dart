import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/login/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            image(AppImages.loginImage, fit: BoxFit.cover).expanded(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                image(AppImages.logo, width: 100, height: 100),
                const SizedBox(height: 24),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      textField(hintText: "نام کاربری", controller: controllerUserName).paddingSymmetric(vertical: 8),
                      textField(hintText: "رمز عبور", controller: controllerPassword).paddingSymmetric(vertical: 8),
                      button(title: "ورود", onTap: login).paddingSymmetric(vertical: 8),
                    ],
                  ).paddingSymmetric(horizontal: context.width / 10),
                ),
              ],
            ).expanded(),
          ],
        ),
      );
}
