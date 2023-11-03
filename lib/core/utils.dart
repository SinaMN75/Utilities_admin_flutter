part of 'core.dart';

S s = S.of(context);

void uploadImage({required final Uint8List byte, required final MapEntry<String, String> form}) async {
  final FormData formData = FormData(<String, dynamic>{
    'Files': MultipartFile(byte, filename: ':).png'),
  });
  formData.fields.add(form);
  await GetConnect().post(
    "https://api.sinamn75.com/api/Media",
    formData,
    headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
    contentType: "multipart/form-data",
  );
}
String getPrice(final int i)=> NumberFormat('###,###,###,###,000').format(i);
bool hasMatch(final String? value, final String pattern) => (value == null) ? false : RegExp(pattern).hasMatch(value);

bool isPhoneNumber(final String s) {
  if (s.length > 16 || s.length < 9) return false;
  return hasMatch(s, r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
}

FormFieldValidator<String> validateNotEmpty() => (final String? value) {
      if (value!.isEmpty) return s.thisFieldRequired;
      return null;
    };

FormFieldValidator<String> validateEmail() => (final String? value) {
      if (value!.isEmpty) return s.thisFieldRequired;
      if (!value.isEmail) return s.wrongEmail;
      return null;
    };

FormFieldValidator<String> validatePhone() => (final String? value) {
      if (value!.isEmpty) return s.thisFieldRequired;
      if (!isPhoneNumber(value)) return s.phoneNumberIsWrong;
      return null;
    };

FormFieldValidator<String> validateNumber() => (final String? value) {
      if (value!.isEmpty) return s.thisFieldRequired;
      if (!GetUtils.isNumericOnly(value)) return s.eneteredNumberIsNotCorrect;
      return null;
    };

String shareProductLink(final String username, final String product) => "http://directshod.com/$username/$product";

void logout() => dialog(
      const AlertDialog(
        title: Text("خروج از سیستم"),
        content: Text("آیا از خروج از سیستم اطمینان دارید؟"),
        actions: <Widget>[
          TextButton(onPressed: back, child: Text("انصراف")),
          TextButton(
            onPressed: clearData,
            child: Text("تایید"),
          ),
        ],
      ),
    );

bool isLoggedIn() => getString(UtilitiesConstants.token) == null ? false : true;
