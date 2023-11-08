import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/login/otp_page.dart';
import 'package:utilities_admin_flutter/views/pages/splash/splash_page.dart';

mixin LoginController {
  Rx<PageState> state = PageState.initial.obs;

  final UserDataSource _userDataSource = UserDataSource(baseUrl: AppConstants.baseUrl);

  final TextEditingController controllerPhone = TextEditingController();
  final TextEditingController controllerOtp = TextEditingController();
  final TextEditingController controllerUserName = TextEditingController(text: "admin");
  final TextEditingController controllerPassword = TextEditingController(text: "1234");



  void init() {}

  void login() {

    showEasyLoading();
    _userDataSource.getVerificationCodeForLogin(
      dto: GetMobileVerificationCodeForLoginDto(mobile: controllerPhone.text),
      onResponse: (final GenericResponse<UserReadDto> response) {
       push(OtpPage(mobile:controllerPhone.text));
        dismissEasyLoading();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }


  void verification() {
    if (controllerOtp.text.length > 3) {
      showEasyLoading();
      _userDataSource.verifyCodeForLogin(
        dto: VerifyMobileForLoginDto(
          mobile: controllerPhone.text,
          verificationCode: controllerOtp.text,
        ),
        onResponse: (final GenericResponse<UserReadDto> response) {
          setData(UtilitiesConstants.userId, response.result?.id);
          setData(UtilitiesConstants.token, "Bearer ${response.result?.token}");
          Core.user = response.result!;
          offAll(const SplashPage());
          dismissEasyLoading();
        },
        onError: (final GenericResponse<dynamic> response) {},
      );
    } else {
      snackbarRed(title: "خطا", subtitle: "کد تایید نامعتبر است");
    }
  }
}
