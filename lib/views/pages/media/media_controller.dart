import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin MediaController {
  final MediaDataSource _mediaDataSource = MediaDataSource(baseUrl: AppConstants.baseUrl);
  Rx<PageState> state = PageState.initial.obs;

  final RxList<MediaReadDto> list = <MediaReadDto>[].obs;

  void init() {
    read();
  }

  void read() {
    state.loading();
    _mediaDataSource.filter(
      dto: MediaFilterDto(pageNumber: 1, pageSize: 1000),
      onResponse: (final GenericResponse<MediaReadDto> response) {
        list(response.resultList);
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void delete({required final MediaReadDto dto}) {
    showEasyLoading();
    _mediaDataSource.delete(
      id: dto.id!,
      onResponse: () {
        dismissEasyLoading();
        list.removeWhere((final MediaReadDto i) => i.id == dto.id);
        back();
      },
      onError: () {},
    );
  }
}
