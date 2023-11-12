import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin OrderController {
  Rx<PageState> state = PageState.initial.obs;
  late String? userId;

  TextEditingController payNumberController = TextEditingController();

  final RxList<OrderReadDto> list = <OrderReadDto>[].obs;
  final RxList<OrderReadDto> filteredList = <OrderReadDto>[].obs;
  OrderReadDto orderReadDto = OrderReadDto();

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
        userId: userId,
        pageNumber: pageNumber,
        payNumber: payNumberController.text.length > 1 ? payNumberController.text : null,
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

  void delete({required final OrderReadDto dto}) => alertDialog(
        title: "خذف",
        subtitle: "آیا از حذف سفارش اطمینان دارید",
        action1: (
          "بله",
          () {
            showEasyLoading();
            _dataSource.delete(
              id: dto.id!,
              onResponse: (final GenericResponse<dynamic> response) {
                snackbarGreen(title: "", subtitle: "حذف محصول ${dto.orderNumber} انجام شد");
                list.removeWhere((final OrderReadDto i) => i.id == dto.id);
                filteredList.removeWhere((final OrderReadDto i) => i.id == dto.id);
              },
              onError: (final GenericResponse<dynamic> response) {},
            );
          }
        ),
      );

  void readById({required final String orderId}) {
    state.loading();
    _dataSource.readById(
      id: orderId,
      onResponse: (final GenericResponse<OrderReadDto> response) {
        orderReadDto = response.result!;
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void update({required final OrderCreateUpdateDto dto}) {
    //
    _dataSource.update(
      dto: dto,
      onResponse: (final GenericResponse<OrderReadDto> response) {
        //
      },
      onError: (final GenericResponse<dynamic> errorResponse) {},
      failure: (final String error) {},
    );
  }
}
