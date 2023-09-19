import 'package:utilities/data/dto/order.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin DashboardController {
  Rx<PageState> state = PageState.initial.obs;
  Rx<PageState> orderState = PageState.initial.obs;
  List<OrderReadDto> orders = <OrderReadDto>[];
  List<CategoryReadDto> categories = <CategoryReadDto>[];
  List<UserReadDto> users = <UserReadDto>[];
  List<ProductReadDto> products = <ProductReadDto>[];
  RxInt categoriesCount = 0.obs;
  RxInt ordersCount = 0.obs;
  RxInt usersCount = 0.obs;
  RxInt productsCount = 0.obs;

  final OrderDataSource _orderDataSource = OrderDataSource(baseUrl: AppConstants.baseUrl);
  final CategoryDataSource _categoryDataSource = CategoryDataSource(baseUrl: AppConstants.baseUrl);
  final UserDataSource _userDataSource = UserDataSource(baseUrl: AppConstants.baseUrl);
  final ProductDataSource _productDataSource = ProductDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    readOrders();
  }

  void readOrders() {
    orderState.loading();
    _orderDataSource.filter(
      dto: OrderFilterDto(pageSize: 10, pageNumber: 1),
      onResponse: (final GenericResponse<OrderReadDto> response) {
        orders = response.resultList ?? <OrderReadDto>[];
        ordersCount(response.totalCount ?? 0);
        orderState.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void readCardsData() {
    _categoryDataSource.filter(
      dto: CategoryFilterDto(),
      onResponse: (final GenericResponse<CategoryReadDto> response) {
        categories = response.resultList ?? <CategoryReadDto>[];
        categoriesCount(response.totalCount ?? -1);
      },
      onError: (final GenericResponse<dynamic> response) {},
    );

    _userDataSource.filter(
      dto: UserFilterDto(),
      onResponse: (final GenericResponse<UserReadDto> response) {
        users = response.resultList ?? <UserReadDto>[];
        usersCount(response.totalCount ?? -1);
      },
      onError: (final GenericResponse<dynamic> response) {},
    );

    _productDataSource.filter(
      dto: ProductFilterDto(),
      onResponse: (final GenericResponse<ProductReadDto> response) {
        products = response.resultList ?? <ProductReadDto>[];
        productsCount(response.totalCount ?? -1);
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }
}
