import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin WithdrawalController {
  Rx<PageState> state = PageState.initial.obs;

  List<WithdrawReadDto> list = <WithdrawReadDto>[];
  RxList<WithdrawReadDto> filteredList = <WithdrawReadDto>[].obs;

  final WithdrawDataSource _dataSource = WithdrawDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    read();
  }

  void read() {
    state.loading();
    _dataSource.filter(
      dto: WithdrawFilterDto(showUser: true),
      onResponse: (final GenericResponse<WithdrawReadDto> response) {
        list = response.resultList!;
        filteredList(list);
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void update({required final WithdrawUpdateDto dto}) {
    _dataSource.update(
      dto: WithdrawUpdateDto(id: dto.id, state: dto.state),
      onResponse: (final GenericResponse<WithdrawReadDto> response) {
        snackbarDone();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }
}
