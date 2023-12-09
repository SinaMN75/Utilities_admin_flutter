import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/splash/splash_page.dart';

mixin LoginController {
  Rx<PageState> state = PageState.initial.obs;

  final UserDataSource _userDataSource = UserDataSource(baseUrl: AppConstants.baseUrl);

  final TextEditingController controllerUserName = TextEditingController(text: "info@sinamn75.com");
  final TextEditingController controllerPassword = TextEditingController(text: "1234");

  void init() {}

  void login() {
    showEasyLoading();
    _userDataSource.loginWithPassword(
      dto: LoginWithPasswordDto(email: controllerUserName.text, password: controllerPassword.text),
      onResponse: (final GenericResponse<UserReadDto> response) {
        setData(UtilitiesConstants.userId, response.result?.id);
        setData(UtilitiesConstants.token, "Bearer ${response.result?.token}");
        Core.user = response.result!;
        offAll(const SplashPage());
        dismissEasyLoading();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }
}
