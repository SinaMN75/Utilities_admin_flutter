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

String shareProductLink(final String username, final String product) => "http://directshod.com/$username/$product";

bool isLoggedIn() => getString(UtilitiesConstants.token) == null ? false : true;
