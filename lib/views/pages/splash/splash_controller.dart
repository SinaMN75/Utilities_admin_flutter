import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/login/login_page.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_page.dart';

mixin SplashController {
  Rx<PageState> state = PageState.initial.obs;

  final UserDataSource _userDataSource = UserDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    delay(1000, () {
      if (getString(UtilitiesConstants.token) == null) {
        offAll(const LoginPage());
      } else {
        _userDataSource.readById(
          id: getString(AppConstants.userId)!,
          onResponse: (final GenericResponse<UserReadDto> response) {},
          onError: (final GenericResponse<dynamic> response) {},
        );
        offAll(const MainPage());
      }
    });
  }
}
