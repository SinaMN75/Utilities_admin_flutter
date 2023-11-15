import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/comments/comments_page.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_controller.dart';
import 'package:utilities_admin_flutter/views/pages/orders/order_page.dart';
import 'package:utilities_admin_flutter/views/pages/products/product_page.dart';
import 'package:utilities_admin_flutter/views/pages/tractions/transactions_page.dart';
import 'package:utilities_admin_flutter/views/pages/users/user_create_update/user_create_update_page.dart';

mixin UserController {
  Rx<PageState> state = PageState.initial.obs;

  final RxList<UserReadDto> list = <UserReadDto>[].obs;

  final TextEditingController controllerFirstName = TextEditingController();
  final TextEditingController controllerLastName = TextEditingController();
  final TextEditingController controllerPhoneNumber = TextEditingController();
  final TextEditingController controllerUserName = TextEditingController();
  final RxBool suspend = false.obs;

  int pageNumber = 1;
  int pageCount = 0;

  final UserDataSource _dataSource = UserDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    if (list.isEmpty)
      filter();
    else
      state.loaded();
  }

  void filter() {
    state.loading();
    _dataSource.filter(
      dto: UserFilterDto(
        showSuspend: suspend.value,
        firstName: controllerFirstName.text.nullIfEmpty(),
        lastName: controllerLastName.text.nullIfEmpty(),
        phoneNumber: controllerPhoneNumber.text.nullIfEmpty(),
        appUserName: controllerUserName.text.nullIfEmpty(),
        showMedia: true,
        pageSize: 20,
        pageNumber: pageNumber,
      ),
      onResponse: (final GenericResponse<UserReadDto> response) {
        list(response.resultList);
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void edit(final UserReadDto dto) => tabWidget.insert(0, UserCreateUpdatePage(dto: dto));

  void transaction(final UserReadDto dto) => tabWidget.insert(0, TransactionsPage(userId: dto.id));

  void orderPage(final UserReadDto dto) => tabWidget.insert(0, OrderPage(userId: dto.id));

  void comments(final UserReadDto dto) => tabWidget.insert(0, CommentsPage(userId: dto.id));

  void productPage(final UserReadDto dto) => tabWidget.insert(0, ProductPage(userId: dto.id));
}
