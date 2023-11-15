import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin UserCreateUpdateController {
  late UserReadDto dto;
  final Rx<PageState> state = PageState.initial.obs;
  final Rx<PageState> stateProfilePhoto = PageState.initial.obs;

  final UserDataSource _userDataSource = UserDataSource(baseUrl: AppConstants.baseUrl);
  final MediaDataSource _mediaDataSource = MediaDataSource(baseUrl: AppConstants.baseUrl);

  RxBool suspend = false.obs;

  DateTime birthDate = DateTime.now();
  final Rx<GenderType> genderType = GenderType.male.obs;
  final TextEditingController controllerFirstName = TextEditingController();
  final TextEditingController controllerLastName = TextEditingController();
  final TextEditingController controllerUserName = TextEditingController();
  final TextEditingController controllerInstagram = TextEditingController();
  final TextEditingController controllerBio = TextEditingController();
  final TextEditingController controllerState = TextEditingController();
  final TextEditingController controllerPhoneNumber = TextEditingController();
  final TextEditingController controllerBirthdate = TextEditingController();
  final TextEditingController controllerAdminUserName = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  RxList<TagUser> adminAccess = <TagUser>[
    TagUser.adminCategoryRead,
    TagUser.adminCategoryUpdate,
    TagUser.adminProductRead,
    TagUser.adminProductUpdate,
    TagUser.adminUserRead,
    TagUser.adminUserUpdate,
    TagUser.adminReportRead,
    TagUser.adminReportUpdate,
    TagUser.adminTransactionRead,
    TagUser.adminTransactionUpdate,
    TagUser.adminOrderRead,
    TagUser.adminOrderUpdate,
    TagUser.adminContentRead,
    TagUser.adminContentUpdate,
    TagUser.adminCommentRead,
    TagUser.adminCommentUpdate,
  ].obs;

  RxList<int> selectedAdminAccess = <int>[].obs;

  void setSelectedValue(final List<TagUser>? value) {
    selectedAdminAccess(value?.map((final TagUser e) => e.number).toList());
  }

  void init() {
    controllerFirstName.text = dto.firstName ?? "";
    controllerLastName.text = dto.lastName ?? "";
    controllerUserName.text = dto.appUserName ?? "";
    controllerBio.text = dto.bio ?? "";
    controllerState.text = dto.state ?? "";
    controllerPhoneNumber.text = dto.appPhoneNumber ?? "";
    controllerInstagram.text = dto.jsonDetail?.instagram ?? "";
    controllerAdminUserName.text = dto.email ?? "";
    controllerBirthdate.text = Jalali.fromDateTime(DateTime.parse(dto.birthdate ?? DateTime.now().toIso8601String())).formatCompactDate();
    if (dto.tags!.contains(GenderType.male.number))
      genderType(GenderType.male);
    else
      genderType(GenderType.female);

    selectedAdminAccess(dto.tags);
    suspend(dto.suspend);
  }

  void uploadProfileImage() async {
    final XFile? image = await imagePicker();
    if (image != null) {
      final CroppedFile? croppedImage = await cropImage(filePath: image.path);
      stateProfilePhoto.loading();
      state.loading();
      dto.media?.forEach((final MediaReadDto i) async {
        await _mediaDataSource.delete(
          id: i.id!,
          onResponse: () {},
          onError: () {},
        );
      });
      delay(100, () async {
        await GetConnect().post(
          "https://api.sinamn75.com/api/Media",
          FormData(<String, dynamic>{
            'Files': MultipartFile(await croppedImage?.readAsBytes(), filename: ':).png'),
            "UserId": dto.id,
          }),
          headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
          contentType: "multipart/form-data",
        );
        await _userDataSource.readById(
          id: dto.id,
          onResponse: (final GenericResponse<UserReadDto> response) {
            dto = response.result!;
            state.loaded();
            stateProfilePhoto.loaded();
          },
          onError: (final GenericResponse<dynamic> response) {},
        );
      });
    }
  }

  void editProfile() {
    showEasyLoading();
    _userDataSource.update(
      dto: UserCreateUpdateDto(
        id: dto.id,
        firstName: controllerFirstName.text,
        lastName: controllerLastName.text,
        appUserName: controllerUserName.text,
        bio: controllerBio.text,
        birthDate: birthDate.toIso8601String(),
        appPhoneNumber: controllerPhoneNumber.text,
        state: controllerState.text,
        instagram: controllerInstagram.text,
        suspend: suspend.value,
        email: controllerAdminUserName.text,
        password: controllerPassword.text.isNotEmpty ? controllerPassword.text : null,
        tags: <int>[genderType.value.number, ...selectedAdminAccess],
      ),
      onResponse: (final GenericResponse<UserReadDto> response) {
        dto = response.result!;
        dismissEasyLoading();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }
}
