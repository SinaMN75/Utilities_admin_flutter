import 'package:utilities/data/dto/dashboard_data.dart';
import 'package:utilities/data/dto/order.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin DashboardController {
  Rx<PageState> state = PageState.initial.obs;
  Rx<PageState> orderState = PageState.initial.obs;
  Rx<PageState> cardsState = PageState.initial.obs;
  List<OrderReadDto> orders = <OrderReadDto>[];
  late DashboardDataReadDto dashboardDataReadDto;

  final OrderDataSource _orderDataSource = OrderDataSource(baseUrl: AppConstants.baseUrl);
  final AppSettingsDataSource _appSettingsDataSource = AppSettingsDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    readOrders();
    readDashboardData();
  }

  void readOrders() {
    orderState.loading();
    _orderDataSource.filter(
      dto: OrderFilterDto(pageSize: 10, pageNumber: 1),
      onResponse: (final GenericResponse<OrderReadDto> response) {
        orders = response.resultList ?? <OrderReadDto>[];
        orderState.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void readDashboardData() {
    _appSettingsDataSource.readDashboardData(
      onResponse: (final GenericResponse<DashboardDataReadDto> response) {
        dashboardDataReadDto = response.result!;
        cardsState.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }
}
