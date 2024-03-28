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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              Sample.loremPicsum(width: context.width, height: context.height),
            ),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints(),
        body: Card(
          child: Form(
            child: Column(
              children: <Widget>[
                image(
                  AppImages.logo,
                  width: 100,
                  height: 100,
                ).paddingSymmetric(vertical: 8),
                textField(
                  hintText: "نام کاربری",
                  controller: controllerUserName,
                ).paddingSymmetric(vertical: 8),
                textField(
                  hintText: "رمز عبور",
                  controller: controllerPassword,
                ).paddingSymmetric(vertical: 8),
                button(title: "ورود", onTap: login).paddingSymmetric(vertical: 8),
              ],
            ),
          ).paddingAll(50),
        ).container(width: 700, height: 500).alignAtCenter(),
      );
}
