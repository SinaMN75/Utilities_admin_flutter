import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin ContentController {
  final ContentDataSource _dataSource = ContentDataSource(baseUrl: AppConstants.baseUrl);
  final MediaDataSource _mediaDataSource = MediaDataSource(baseUrl: AppConstants.baseUrl);
  Rx<PageState> state = PageState.initial.obs;

  final RxList<ContentReadDto> list = <ContentReadDto>[].obs;

  void init() {
    read();
  }

  void read() {
    state.loading();
    _dataSource.read(
      onResponse: (final GenericResponse<ContentReadDto> response) {
        list(response.resultList);
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void delete({required final ContentReadDto dto}) {
    showEasyLoading();
    _dataSource.delete(
      id: dto.id!,
      onResponse: (final GenericResponse<dynamic> response) {
        snackbarGreen(title: "", subtitle: "حذف دسته بندی ${dto.title} انجام شد");
        list.removeWhere((final ContentReadDto i) => i.id == dto.id);
        back();
        dismissEasyLoading();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void create({required final ContentCreateUpdateDto dto}) {
    showEasyLoading();
    _dataSource.create(
      dto: dto,
      onResponse: (final GenericResponse<ContentReadDto> response) {
        snackbarDone();
        dismissEasyLoading();
        back();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void update({required final ContentCreateUpdateDto dto}) {
    showEasyLoading();
    _dataSource.update(
      dto: dto,
      onResponse: (final GenericResponse<ContentReadDto> response) {
        snackbarDone();
        dismissEasyLoading();
        back();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }
}
