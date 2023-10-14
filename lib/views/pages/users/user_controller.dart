import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/users/user_create_update/user_create_update_page.dart';

mixin UserController {
  Rx<PageState> state = PageState.initial.obs;

  final RxList<UserReadDto> list = <UserReadDto>[].obs;

  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerTitleTr1 = TextEditingController();

  final UserDataSource _dataSource = UserDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    if (list.isEmpty)
      read();
    else
      state.loaded();
  }

  void read() {
    state.loading();
    _dataSource.filter(
      dto: UserFilterDto(),
      onResponse: (final GenericResponse<UserReadDto> response) {
        list(response.resultList);
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void edit(final UserReadDto dto) => push(UserCreateUpdatePage(dto: dto));
}
