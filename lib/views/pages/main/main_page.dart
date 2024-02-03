import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/categories/category_page.dart';
import 'package:utilities_admin_flutter/views/pages/comments/comments_page.dart';
import 'package:utilities_admin_flutter/views/pages/content/content_page.dart';
import 'package:utilities_admin_flutter/views/pages/dashboard/dashboard_page.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_controller.dart';
import 'package:utilities_admin_flutter/views/pages/orders/order_page.dart';
import 'package:utilities_admin_flutter/views/pages/products/product_page.dart';
import 'package:utilities_admin_flutter/views/pages/report/report_page.dart';
import 'package:utilities_admin_flutter/views/pages/splash/splash_page.dart';
import 'package:utilities_admin_flutter/views/pages/transactions/transactions_page.dart';
import 'package:utilities_admin_flutter/views/pages/users/user_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with MainController, TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: tabWidget.length, vsync: this);
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return AdminScaffold(
      appBar: AppBar(title: const Text('ادمین پنل')),
      sideBar: SideBar(
        items: <AdminMenuItem>[
          AdminMenuItem(
            title: 'داشبورد',
            route: MainPageType.dashboard.title,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'دسته بندی',
            route: MainPageType.category.title,
            icon: Icons.category,
          ),
          AdminMenuItem(
            title: "محصولات",
            route: MainPageType.product.title,
            icon: Icons.card_travel_outlined,
          ),
          AdminMenuItem(
            title: "نظرات",
            route: MainPageType.comment.title,
            icon: Icons.comment_outlined,
          ),
          AdminMenuItem(
            title: "کاربران",
            route: MainPageType.user.title,
            icon: Icons.person_outline,
          ),
          AdminMenuItem(
            title: "ریپورت‌ها",
            route: MainPageType.report.title,
            icon: Icons.report_outlined,
          ),
          AdminMenuItem(
            title: "تراکنش‌ها",
            route: MainPageType.transaction.title,
            icon: Icons.credit_card_outlined,
          ),
          AdminMenuItem(
            title: "سفارشات",
            route: MainPageType.order.title,
            icon: Icons.shopping_cart_outlined,
          ),
          AdminMenuItem(
            title: 'محتوا',
            icon: Icons.file_copy,
            route: MainPageType.content.title,
          ),
          AdminMenuItem(
            title: 'فایل‌ها',
            icon: Icons.perm_media_outlined,
            route: MainPageType.media.title,
          ),
          const AdminMenuItem(title: 'خروج از سیستم', icon: Icons.logout, route: "logout"),
        ],
        onSelected: (final AdminMenuItem item) {
          if (item.route == MainPageType.dashboard.title) addTab(const DashboardPage());
          if (item.route == MainPageType.category.title) addTab(const CategoryPage());
          if (item.route == MainPageType.product.title) addTab(const ProductPage());
          if (item.route == MainPageType.comment.title) addTab(const CommentsPage());
          if (item.route == MainPageType.report.title) addTab(const ReportPage());
          if (item.route == MainPageType.transaction.title) addTab(const TransactionsPage());
          if (item.route == MainPageType.content.title) addTab(const ContentPage());
          if (item.route == MainPageType.user.title) addTab(const UserPage());
          if (item.route == MainPageType.order.title) addTab(const OrderPage());
          if (item.route == "logout")
            logout(onLoggedOut: () {
              clearData();
              offAll(const SplashPage());
            });
          Get.forceAppUpdate();
        },
        selectedRoute: '',
      ),
      body: Obx(
        () => defaultTabBar(
          controller: tabController,
          children: tabWidget,
          physics: const NeverScrollableScrollPhysics(),
          tabBar: TabBar(
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: tabWidget
                  .mapIndexed(
                    (final int index, final Widget i) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            if (tabWidget.length != 1) tabWidget.removeAt(index);
                          },
                          icon: const Icon(Icons.close),
                        ),
                        Text(i.key.toString().replaceAll("[<'", "").replaceAll("'>]", "")),
                      ],
                    ),
                  )
                  .toList()),
        ),
      ),
    );
  }

  void addTab(final Widget widget) {
    if (tabWidget.contains(widget)) {
      tabController.index = tabWidget.indexOf(widget);
    } else {
      tabWidget.insert(0, widget);
      tabController.dispose();
      tabController = TabController(length: tabWidget.length, vsync: this);
    }
  }
}
