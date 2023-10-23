import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_controller.dart';
import 'package:utilities_admin_flutter/views/pages/products/product_create_update/product_create_update_page.dart';

mixin OrderController {
  Rx<PageState> state = PageState.initial.obs;

  final RxList<OrderReadDto> list = <OrderReadDto>[].obs;
  final RxList<OrderReadDto> filteredList = <OrderReadDto>[].obs;

  final TextEditingController controllerTitle = TextEditingController();
  final RxInt selectedOrderTag = TagOrder.paid.number.obs;

  int pageNumber = 1;
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
        tags: selectedOrderTag.value == 0 ? null : <int>[selectedOrderTag.value],
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

  void update({required final OrderReadDto dto}) => mainWidget(const ProductCreateUpdatePage());
}
