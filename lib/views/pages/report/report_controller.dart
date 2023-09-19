import 'package:utilities/data/dto/report.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin ReportController {
  Rx<PageState> state = PageState.initial.obs;

  final RxList<ReportReadDto> list = <ReportReadDto>[].obs;
  final RxList<ReportReadDto> filteredList = <ReportReadDto>[].obs;

  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerTitleTr1 = TextEditingController();

  final ReportDataSource _reportDataSource = ReportDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    if (list.isEmpty)
      read();
    else
      state.loaded();
  }

  void read() {
    state.loading();
    _reportDataSource.filter(
      dto: ReportFilterDto(product: true),
      onResponse: (final GenericResponse<ReportReadDto> response) {
        list(response.resultList);
        filteredList(list);
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }
}
