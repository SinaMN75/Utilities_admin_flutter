import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/responsive.dart';
import 'package:utilities_admin_flutter/views/pages/categories/category_page.dart';
import 'package:utilities_admin_flutter/views/pages/dashboard/dashboard_controller.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_controller.dart';
import 'package:utilities_admin_flutter/views/pages/media/media_page.dart';
import 'package:utilities_admin_flutter/views/pages/orders/order_page.dart';
import 'package:utilities_admin_flutter/views/pages/products/product_page.dart';
import 'package:utilities_admin_flutter/views/pages/report/report_page.dart';
import 'package:utilities_admin_flutter/views/pages/transactions/transactions_page.dart';
import 'package:utilities_admin_flutter/views/pages/users/user_page.dart';
import 'package:utilities_admin_flutter/views/widget/table.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  Key? get key => const Key("داشبورد");

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with DashboardController, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      primary: false,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          _header(),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  _cards(),
                  const SizedBox(height: 16),
                  Obx(() => orderState.isLoaded() ? _completedOrders() : const SizedBox()),
                  if (Responsive.isMobile()) const SizedBox(height: 16),
                  if (Responsive.isMobile()) _products(),
                ],
              ).expanded(flex: 5),
              if (!Responsive.isMobile()) Expanded(flex: 2, child: _products()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _header() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text("داشبورد مدیریت").titleLarge(),
          Text(Core.user.firstName ?? "").container(
            radius: 10,
            backgroundColor: context.theme.colorScheme.secondary.withOpacity(0.1),
            margin: const EdgeInsets.only(left: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16 / 2),
          ),
        ],
      );

  Widget _products() => Obx(
        () => cardsState.isLoaded()
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("محصولات").headlineSmall().bold(),
                  _chartDataCard(
                    iconData: Icons.queue,
                    title: "در صف بررسی",
                    trailing: dashboardDataReadDto.inQueueProducts.toString(),
                    onTap: () => Core.user.tags.contains(TagUser.adminProductRead.number)
                        ? tabWidget.insert(
                            0,
                            const ProductPage(),
                          )
                        : null,
                  ),
                  _chartDataCard(
                    iconData: Icons.done,
                    title: "منتشر شده",
                    trailing: dashboardDataReadDto.releasedProducts.toString(),
                    onTap: () => Core.user.tags.contains(TagUser.adminProductRead.number)
                        ? tabWidget.insert(
                            0,
                            const ProductPage(),
                          )
                        : null,
                  ),
                  _chartDataCard(
                    iconData: Icons.remove,
                    title: "رد شده",
                    trailing: dashboardDataReadDto.notAcceptedProducts.toString(),
                    onTap: () => Core.user.tags.contains(TagUser.adminProductRead.number)
                        ? tabWidget.insert(
                            0,
                            const ProductPage(),
                          )
                        : null,
                  ),
                ],
              )
            : const SizedBox(),
      ).container(
        padding: const EdgeInsets.all(16),
        backgroundColor: context.theme.colorScheme.background,
        radius: 10,
      );

  Widget _chartDataCard({
    required final String title,
    required final IconData iconData,
    required final String trailing,
    required final VoidCallback onTap,
  }) =>
      Row(
        children: <Widget>[
          Icon(iconData),
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis).paddingSymmetric(horizontal: 16).expanded(),
          Text(trailing),
        ],
      )
          .container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(16),
            radius: 16,
            borderColor: context.theme.colorScheme.primary,
            borderWidth: 2,
          )
          .onTap(onTap);

  Widget _completedOrders() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text("فروشنده")),
                DataColumn(label: Text("خریدار")),
                DataColumn(label: Text("قیمت کل")),
              ],
              rows: orders
                  .mapIndexed(
                    (final int index, final OrderReadDto i) => DataRow(
                      color: dataTableRowColor(index),
                      cells: <DataCell>[
                        DataCell(Text(i.productOwner?.fullName ?? "")),
                        DataCell(Text(i.user?.fullName ?? "")),
                        DataCell(Text(i.totalPrice.toTomanMoneyPersian())),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ).container(
        backgroundColor: context.theme.colorScheme.background,
        radius: 12,
        padding: const EdgeInsets.all(16),
      );

  Widget _cards() => Column(
        children: <Widget>[
          Obx(
            () => cardsState.isLoaded()
                ? Wrap(
                    children: <Widget>[
                      _card(
                        title: "دسته‌بندی‌ها",
                        count: dashboardDataReadDto.categories.toString(),
                        color: Colors.red,
                        iconData: Icons.category_outlined,
                      ).onTap(
                        () => Core.user.tags.contains(TagUser.adminCategoryRead.number)
                            ? tabWidget.insert(
                                0,
                                const CategoryPage(),
                              )
                            : null,
                      ),
                      _card(
                        title: "کاربران",
                        count: dashboardDataReadDto.users.toString(),
                        color: Colors.blue,
                        iconData: Icons.person_outline,
                      ).onTap(
                        () => Core.user.tags.contains(TagUser.adminUserRead.number)
                            ? tabWidget.insert(
                                0,
                                const UserPage(),
                              )
                            : null,
                      ),
                      _card(
                        title: "سفارشات",
                        count: dashboardDataReadDto.orders.toString(),
                        color: Colors.green,
                        iconData: Icons.shopping_cart_outlined,
                      ).onTap(
                        () => Core.user.tags.contains(TagUser.adminOrderRead.number)
                            ? tabWidget.insert(
                                0,
                                const OrderPage(),
                              )
                            : null,
                      ),
                      _card(
                        title: "محصولات",
                        count: dashboardDataReadDto.products.toString(),
                        color: Colors.orange,
                        iconData: Icons.dashboard_outlined,
                      ).onTap(
                        () => Core.user.tags.contains(TagUser.adminProductRead.number)
                            ? tabWidget.insert(
                                0,
                                const ProductPage(),
                              )
                            : null,
                      ),
                      _card(
                        title: "فایل‌ها",
                        count: dashboardDataReadDto.media.toString(),
                        color: Colors.purple,
                        iconData: Icons.dashboard_outlined,
                      ).onTap(() => tabWidget.insert(0, const MediaPage())),
                      _card(
                        title: "تراکنش‌ها",
                        count: dashboardDataReadDto.transactions.toString(),
                        color: Colors.indigo,
                        iconData: Icons.dashboard_outlined,
                      ).onTap(
                        () => Core.user.tags.contains(TagUser.adminTransactionRead.number)
                            ? tabWidget.insert(
                                0,
                                const TransactionsPage(),
                              )
                            : null,
                      ),
                      _card(
                        title: "ریپورت‌ها",
                        count: dashboardDataReadDto.reports.toString(),
                        color: Colors.brown,
                        iconData: Icons.dashboard_outlined,
                      ).onTap(
                        () => Core.user.tags.contains(TagUser.adminReportRead.number)
                            ? tabWidget.insert(
                                0,
                                const ReportPage(),
                              )
                            : null,
                      ),
                      _card(
                        title: "آدرس‌ها",
                        count: dashboardDataReadDto.address.toString(),
                        color: Colors.teal,
                        iconData: Icons.dashboard_outlined,
                      ),
                    ],
                  )
                : const CircularProgressIndicator().alignAtCenter(),
          ),
        ],
      );

  Widget _card({
    required final String title,
    required final String count,
    required final Color color,
    required final IconData iconData,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(iconData, color: color).container(
            padding: const EdgeInsets.all(8),
            backgroundColor: color.withOpacity(0.1),
            radius: 12,
          ),
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          LinearProgressIndicator(color: color, value: 1),
          Text(count).bodySmall(color: color),
        ],
      ).container(
        width: 250,
        height: 170,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(12),
        backgroundColor: color.withOpacity(0.1),
        radius: 10,
      );
}
