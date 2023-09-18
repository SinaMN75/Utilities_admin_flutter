import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/login/login_page.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_page.dart';

mixin SplashController {
  Rx<PageState> state = PageState.initial.obs;

  void init() {
    delay(1000, () {
      if (getString(UtilitiesConstants.token) == null)
        offAll(const LoginPage());
      else
        offAll(const MainPage());
    });
  }
}
