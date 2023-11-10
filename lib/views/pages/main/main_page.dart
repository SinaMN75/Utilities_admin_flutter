import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/about/about_page.dart';
import 'package:utilities_admin_flutter/views/pages/banners/banner_page.dart';
import 'package:utilities_admin_flutter/views/pages/categories/category_page.dart';
import 'package:utilities_admin_flutter/views/pages/comments/comments_page.dart';
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
            if (Core.user.tags!.contains(TagUser.adminTransactionRead.number))
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
                children: <AdminMenuItem>[
                  AdminMenuItem(title: 'درباره ما', route: MainPageType.about.title),
                  AdminMenuItem(title: 'قوانین و مقررات', route: MainPageType.terms.title),
                  AdminMenuItem(title: 'بنر‌ها', route: MainPageType.banner.title),
                ],
              ),
            const AdminMenuItem(title: 'خروج از سیستم', icon: Icons.logout, route: "logout"),
          ],
          onSelected: (final AdminMenuItem item) {
            if (item.route == MainPageType.dashboard.title) mainWidget(const DashboardPage().container());
            if (item.route == MainPageType.about.title) mainWidget(const AboutPage().container());
            if (item.route == MainPageType.terms.title) mainWidget(const TermsPage().container());
            if (item.route == MainPageType.category.title) mainWidget(const CategoryPage().container());
            if (item.route == MainPageType.product.title) mainWidget(const ProductPage().container());
            if (item.route == MainPageType.comment.title) mainWidget(const CommentsPage().container());
            if (item.route == MainPageType.report.title) mainWidget(const ReportPage().container());
            if (item.route == MainPageType.transaction.title) mainWidget(const TransactionsPage().container());
            if (item.route == MainPageType.banner.title) mainWidget(const BannersPage().container());
            if (item.route == MainPageType.productDetail.title) mainWidget(const BannersPage().container());
            if (item.route == MainPageType.user.title) mainWidget(const UserPage().container());
            if (item.route == MainPageType.order.title) mainWidget(const OrderPage().container());
            // if (item.route == MainPageType.withdrawal.title) mainWidget(const WithdrawalPage().container());
            if (item.route == "logout") logout();
            Get.forceAppUpdate();
          },
          selectedRoute: '',
        ),
        body: Obx(() => mainWidget()),
      );
}
