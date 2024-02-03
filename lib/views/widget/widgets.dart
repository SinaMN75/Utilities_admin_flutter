import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

Widget textFieldUser({
  required final Function(UserReadDto dto) onUserSelected,
  final String? text,
}) {
  final TextEditingController controllerPhoneNumber = TextEditingController();
  return textFieldTypeAhead<UserReadDto>(
    text: text,
    hint: "شماره همراه کاربر",
    controller: controllerPhoneNumber,
    itemBuilder: (final BuildContext context, final UserReadDto value) => Text("${value.firstName ?? ""} ${value.lastName} ${value.phoneNumber}").paddingAll(16),
    suggestionsCallback: (final String value) async {
      final RxList<UserReadDto> list = <UserReadDto>[].obs;
      await UserDataSource(baseUrl: AppConstants.baseUrl).filter(
        dto: UserFilterDto(query: controllerPhoneNumber.text),
        onResponse: (final GenericResponse<UserReadDto> response) {
          list(response.resultList);
        },
        onError: (final GenericResponse<dynamic> errorResponse) {},
      );

      return list;
    },
    onSuggestionSelected: (final UserReadDto value) {
      controllerPhoneNumber.text = "${value.firstName ?? ""} ${value.lastName} ${value.phoneNumber}";
      onUserSelected(value);
    },
  ).container(margin: const EdgeInsets.symmetric(horizontal: 8), width: 200);
}
