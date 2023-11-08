import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/login/login_controller.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({required this.mobile,super.key});

 final String mobile;

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with LoginController {
  @override
  void initState() {
    controllerPhone.text=widget.mobile;
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
                      textField(hintText: "کد تایید", controller: controllerOtp, keyboardType: TextInputType.number, maxLength: 11).paddingSymmetric(vertical: 8),
                      // textField(hintText: "رمز عبور", controller: controllerPassword).paddingSymmetric(vertical: 8),
                      button(title: "ورود", onTap: verification).paddingSymmetric(vertical: 8),
                      // const Text('ورود با کد یکبار مصرف').bodyMedium().onTap(() {
                    ],
                  ).paddingSymmetric(horizontal: context.width / 10),
                ),
              ],
            ).expanded(),
          ],
        ),
      );
}
