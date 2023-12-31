import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_page.dart';

mixin SplashController {
  Rx<PageState> state = PageState.initial.obs;

  final UserDataSource _userDataSource = UserDataSource(baseUrl: AppConstants.baseUrl);
  final ContentDataSource _contentDataSource = ContentDataSource(baseUrl: AppConstants.baseUrl);
  final CategoryDataSource _categoryDataSource = CategoryDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    delay(100, () {
      _categoryDataSource.filter(
        dto: CategoryFilterDto(),
        onResponse: (final GenericResponse<CategoryReadDto> response) {
          Core.categories = response.resultList!;
        },
        onError: (final GenericResponse<dynamic> response) {},
      );
      _contentDataSource.read(
        onResponse: (final GenericResponse<ContentReadDto> response) {
          Core.contents = response.resultList!;
        },
        onError: (final GenericResponse<dynamic> response) {},
      );

      _userDataSource.readById(
        id: getString(AppConstants.userId)!,
        onResponse: (final GenericResponse<UserReadDto> response) {
          Core.user = response.result!;
          offAll(const MainPage());
        },
        onError: (final GenericResponse<dynamic> response) {},
      );
    });
  }
}
