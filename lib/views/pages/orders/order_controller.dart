import 'package:utilities/data/dto/order.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/products/product_create_update/product_create_update_page.dart';

mixin OrderController {
  Rx<PageState> state = PageState.initial.obs;

  final RxList<OrderReadDto> list = <OrderReadDto>[].obs;
  final RxList<OrderReadDto> filteredList = <OrderReadDto>[].obs;

  final TextEditingController controllerTitle = TextEditingController();
  final RxInt selectedProductTag = TagProduct.inQueue.number.obs;

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
        tags: selectedProductTag.value == 0 ? null : <int>[selectedProductTag.value],
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

  void update({required final OrderReadDto dto}) {
    push(const ProductCreateUpdatePage());
  }
}
