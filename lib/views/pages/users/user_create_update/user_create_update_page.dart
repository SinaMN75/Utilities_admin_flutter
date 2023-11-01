import 'package:choice/choice.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/users/user_create_update/user_create_update_controller.dart';

class UserCreateUpdatePage extends StatefulWidget {
  const UserCreateUpdatePage({required this.dto, super.key});

  final UserReadDto? dto;

  @override
  State<UserCreateUpdatePage> createState() => _UserCreateUpdatePageState();
}

class _UserCreateUpdatePageState extends State<UserCreateUpdatePage> with UserCreateUpdateController {
  @override
  void initState() {
    if (widget.dto != null) dto = widget.dto!;
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        appBar: AppBar(title: const Text("")),
        body: column(
          crossAxisAlignment: CrossAxisAlignment.start,
          isScrollable: true,
          children: <Widget>[
            const SizedBox(height: 16),
            Obx(() {
              if (stateProfilePhoto.isLoading())
                return const CircularProgressIndicator();
              else
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        image(
                          dto.media.getImage(),
                          placeholder: AppImages.profilePlaceholder,
                          fit: BoxFit.cover,
                          borderRadius: 1000,
                          width: 100,
                          height: 100,
                        ).onTap(uploadProfileImage),
                        const Icon(Icons.edit)
                            .container(
                              padding: const EdgeInsets.all(6),
                              backgroundColor: context.theme.colorScheme.background,
                              radius: 100,
                            )
                            .onTap(uploadProfileImage),
                      ],
                    ),
                  ],
                );
            }),
            textField(text: "نام", controller: controllerFirstName),
            textField(text: "نام خانوادگی", controller: controllerLastName),
            textField(text: "نام کاربری", controller: controllerUserName),
            textField(text: "آیدی اینستاگرام", controller: controllerInstagram),
            const Text("جنسیت"),
            Obx(
              () => Row(
                children: <Widget>[
                  iconTextHorizontal(
                    leading: Radio<GenderType>(value: GenderType.male, groupValue: genderType.value, onChanged: genderType),
                    trailing: const Text("مرد"),
                  ),
                  const SizedBox(width: 20),
                  iconTextHorizontal(
                    leading: Radio<GenderType>(value: GenderType.female, groupValue: genderType.value, onChanged: genderType),
                    trailing: const Text("زن"),
                  ),
                ],
              ),
            ),
            textFieldPersianDatePicker(
              controller: controllerBirthdate,
              text: "تاریخ تولد",
              onChange: (final DateTime dateTime, final Jalali jalali) {
                birthDate = dateTime;
                controllerBirthdate.text = jalali.formatCompactDate();
              },
            ),
            textField(text: "بیوگرافی", controller: controllerBio, lines: 4),
            const SizedBox(height: 16),
            textField(text: "شماره تماس", controller: controllerPhoneNumber, keyboardType: TextInputType.number, maxLength: 12),
            textFieldTypeAhead<String>(
              text: "شهر",
              controller: controllerState,
              onSuggestionSelected: (final String value) => controllerState.text = value,
              suggestionsCallback: (final String pattern) async {
                final List<IranLocationReadDto> list = await LocalDataSource().getIranLocations();
                return list.map((final IranLocationReadDto e) => e.name ?? "").toList();
              },
            ),
            const Divider(),
            Obx(
              () => iconTextHorizontal(
                  leading: Switch(
                    value: suspend.value,
                    onChanged: suspend,
                  ),
                  trailing: const Text("غیر فعال کردن کاربر")),
            ),
            const Text("دسترسی ادمین").headlineSmall().paddingSymmetric(vertical: 8),
            textField(text: "نام کاربری", controller: controllerAdminUserName),
            textField(text: "رمز عبور", controller: controllerPassword),
            Obx(
              () => InlineChoice<TagUser>.multiple(
                clearable: true,
                value: selectedAdminAccess.map(TagUser.byNumber).toList(),
                onChanged: setSelectedValue,
                itemCount: adminAccess.length,
                itemBuilder: (final ChoiceController<TagUser> state, final int i) => ChoiceChip(
                  selected: state.selected(adminAccess[i]),
                  onSelected: state.onSelected(adminAccess[i]),
                  label: Text(adminAccess[i].title),
                ),
                listBuilder: ChoiceList.createWrapped(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25)),
              ),
            ),
            button(title: "ذخیره", onTap: editProfile).paddingSymmetric(vertical: 40),
          ],
        ),
      );
}
