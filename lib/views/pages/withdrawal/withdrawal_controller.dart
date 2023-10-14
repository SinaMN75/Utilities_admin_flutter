import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin WithdrawalController {
  Rx<PageState> state = PageState.initial.obs;

  List<WithdrawReadDto> list = <WithdrawReadDto>[];
  RxList<WithdrawReadDto> filteredList = <WithdrawReadDto>[].obs;

  final WithdrawDataSource _dataSource = WithdrawDataSource(baseUrl: AppConstants.baseUrl);

  void init() {}

  void read() {
    state.loading();
    _dataSource.filter(
      dto: WithdrawFilterDto(),
      onResponse: (final GenericResponse<WithdrawReadDto> response) {
        list = response.resultList!;
        filteredList(list);
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }
}
