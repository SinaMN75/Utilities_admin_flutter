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
        body: Row(
          children: <Widget>[
            image(AppImages.loginImage, fit: BoxFit.cover).container(
              height: context.height,
              width: context.width / 2,
              backgroundColor: context.theme.colorScheme.background,
            ),
            Container(
              height: context.height,
              width: context.width / 2,
              color: context.theme.colorScheme.background,
              child: Container(
                padding: const EdgeInsets.all(42),
                width: context.width / 3,
                height: context.height / 1.5,
                child: Column(children: <Widget>[image(AppImages.logo), const SizedBox(height: 24), _loginScreen(context)]),
              ).alignAtCenter(),
            )
          ],
        ),
      );

  Widget _loginScreen(final BuildContext context) => Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            textField(hintText: "نام کاربری").paddingSymmetric(vertical: 8),
            textField(hintText: "رمز عبور").paddingSymmetric(vertical: 8),
            button(title: "ورود", onTap: login).paddingSymmetric(vertical: 8),
          ],
        ),
      );
}
