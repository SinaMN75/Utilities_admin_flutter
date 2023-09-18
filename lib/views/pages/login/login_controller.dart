import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_page.dart';

mixin LoginController {
  Rx<PageState> state = PageState.initial.obs;

  final UserDataSource _userDataSource = UserDataSource(baseUrl: AppConstants.baseUrl);

  final TextEditingController controllerUserName = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  void init() {}

  void login() {
    showEasyLoading();
    _userDataSource.loginWithPassword(
      dto: LoginWithPassword(email: controllerUserName.text, password: controllerPassword.text),
      onResponse: (final GenericResponse<UserReadDto> response) {
        setData(UtilitiesConstants.token, response.result?.token);
        offAll(const MainPage());
        dismissEasyLoading();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }
}
