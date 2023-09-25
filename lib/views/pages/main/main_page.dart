import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/about/about_page.dart';
import 'package:utilities_admin_flutter/views/pages/banners/banners_page.dart';
import 'package:utilities_admin_flutter/views/pages/categories/category_page.dart';
import 'package:utilities_admin_flutter/views/pages/dashboard/dashboard_page.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_controller.dart';
import 'package:utilities_admin_flutter/views/pages/orders/order_page.dart';
import 'package:utilities_admin_flutter/views/pages/products/product_page.dart';
import 'package:utilities_admin_flutter/views/pages/report/report_page.dart';
import 'package:utilities_admin_flutter/views/pages/terms/terms_page.dart';
import 'package:utilities_admin_flutter/views/pages/tractions/transactions_page.dart';
import 'package:utilities_admin_flutter/views/pages/users/user_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with MainController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => AdminScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Sample')),
        sideBar: SideBar(
          items: <AdminMenuItem>[
            AdminMenuItem(title: 'داشبورد', route: MainPageType.dashboard.title, icon: Icons.dashboard),
            AdminMenuItem(title: 'دسته بندی', route: MainPageType.category.title, icon: Icons.category),
            AdminMenuItem(title: "محصولات", route: MainPageType.product.title, icon: Icons.card_travel_outlined),
            AdminMenuItem(title: "کاربران", route: MainPageType.user.title, icon: Icons.person_outline),
            AdminMenuItem(title: "ریپورت‌ها", route: MainPageType.report.title, icon: Icons.report_outlined),
            AdminMenuItem(title: "تراکنش‌ها", route: MainPageType.transaction.title, icon: Icons.credit_card_outlined),
            AdminMenuItem(title: "سفارشات", route: MainPageType.order.title, icon: Icons.shopping_cart_outlined),
            AdminMenuItem(
              title: 'محتوا',
              icon: Icons.file_copy,
              children: <AdminMenuItem>[
                AdminMenuItem(title: 'درباره ما', route: MainPageType.about.title),
                AdminMenuItem(title: 'قوانین و مقررات', route: MainPageType.terms.title),
                AdminMenuItem(title: 'بنر‌ها', route: MainPageType.banner.title),
              ],
            ),
          ],
          onSelected: (final AdminMenuItem item) {
            if (item.route == MainPageType.dashboard.title) Core.mainPageType(MainPageType.dashboard);
            if (item.route == MainPageType.about.title) Core.mainPageType(MainPageType.about);
            if (item.route == MainPageType.terms.title) Core.mainPageType(MainPageType.terms);
            if (item.route == MainPageType.category.title) Core.mainPageType(MainPageType.category);
            if (item.route == MainPageType.product.title) Core.mainPageType(MainPageType.product);
            if (item.route == MainPageType.report.title) Core.mainPageType(MainPageType.report);
            if (item.route == MainPageType.transaction.title) Core.mainPageType(MainPageType.transaction);
            if (item.route == MainPageType.banner.title) Core.mainPageType(MainPageType.banner);
            if (item.route == MainPageType.productDetail.title) Core.mainPageType(MainPageType.productDetail);
            if (item.route == MainPageType.user.title) Core.mainPageType(MainPageType.user);
            if (item.route == MainPageType.order.title) Core.mainPageType(MainPageType.order);
          },
          selectedRoute: '',
        ),
        body: Obx(() {
          if (Core.mainPageType.value == MainPageType.dashboard) return const DashboardPage();
          if (Core.mainPageType.value == MainPageType.terms) return const TermsPage();
          if (Core.mainPageType.value == MainPageType.about) return const AboutPage();
          if (Core.mainPageType.value == MainPageType.category) return const CategoryPage();
          if (Core.mainPageType.value == MainPageType.product) return const ProductPage();
          if (Core.mainPageType.value == MainPageType.report) return const ReportPage();
          if (Core.mainPageType.value == MainPageType.transaction) return const TransactionsPage();
          if (Core.mainPageType.value == MainPageType.banner) return const BannersPage();
          if (Core.mainPageType.value == MainPageType.user) return const UserPage();
          if (Core.mainPageType.value == MainPageType.order) return const OrderPage();
          return const Placeholder();
        }),
        // body: Text("kkkkk"),
      );
}
