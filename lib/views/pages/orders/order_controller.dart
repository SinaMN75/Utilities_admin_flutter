import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin OrderController {
  Rx<PageState> state = PageState.initial.obs;

  final RxList<OrderReadDto> list = <OrderReadDto>[].obs;
  final RxList<OrderReadDto> filteredList = <OrderReadDto>[].obs;

  final TextEditingController controllerTitle = TextEditingController();
  final RxInt selectedOrderTag = TagOrder.all.number.obs;

  int pageNumber = 1; //
  int pageCount = 0;

  final OrderDataSource _dataSource = OrderDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    if (list.isEmpty)
      read();
    else
      state.loaded();
  }

  void read() {
    state.loading();
    _dataSource.filter(
      dto: OrderFilterDto(
        pageSize: 20,
        pageNumber: pageNumber,
        tags: selectedOrderTag.value == TagOrder.all.number ? <int>[] : <int>[selectedOrderTag.value],
      ),
      onResponse: (final GenericResponse<OrderReadDto> response) {
        pageCount = response.pageCount!;
        list(response.resultList);
        filteredList(list);
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void update({required final OrderCreateUpdateDto dto}) {
    //
    _dataSource.update(
      dto: dto,
      onResponse: (final GenericResponse<OrderReadDto> response) {//
      },
      onError: (final GenericResponse<dynamic> errorResponse) {
      },
      failure: (final String error) {
      },
    );
  }
}
