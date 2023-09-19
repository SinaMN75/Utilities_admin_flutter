import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/about/about_page.dart';
import 'package:utilities_admin_flutter/views/pages/categories/category_page.dart';
import 'package:utilities_admin_flutter/views/pages/dashboard/dashboard_page.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_controller.dart';
import 'package:utilities_admin_flutter/views/pages/products/product_page.dart';
import 'package:utilities_admin_flutter/views/pages/report/report_page.dart';
import 'package:utilities_admin_flutter/views/pages/terms/terms_page.dart';

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
            AdminMenuItem(title: "محصولات", route: MainPageType.product.title, icon: Icons.shopping_cart_rounded),
            AdminMenuItem(title: "ریپورت‌ها", route: MainPageType.report.title, icon: Icons.report_outlined),
            AdminMenuItem(
              title: 'محتوا',
              icon: Icons.file_copy,
              children: <AdminMenuItem>[
                AdminMenuItem(title: 'درباره ما', route: MainPageType.about.title),
                AdminMenuItem(title: 'قوانین و مقررات', route: MainPageType.terms.title),
              ],
            ),
          ],
          onSelected: (final AdminMenuItem item) {
            if (item.route == MainPageType.dashboard.title) mainPageType(MainPageType.dashboard);
            if (item.route == MainPageType.about.title) mainPageType(MainPageType.about);
            if (item.route == MainPageType.terms.title) mainPageType(MainPageType.terms);
            if (item.route == MainPageType.category.title) mainPageType(MainPageType.category);
            if (item.route == MainPageType.product.title) mainPageType(MainPageType.product);
            if (item.route == MainPageType.report.title) mainPageType(MainPageType.report);
          },
          selectedRoute: '',
        ),
        body: Obx(() {
          if (mainPageType.value == MainPageType.dashboard) return const DashboardPage();
          if (mainPageType.value == MainPageType.terms) return const TermsPage();
          if (mainPageType.value == MainPageType.about) return const AboutPage();
          if (mainPageType.value == MainPageType.category) return const CategoryPage();
          if (mainPageType.value == MainPageType.product) return const ProductPage();
          if (mainPageType.value == MainPageType.report) return const ReportPage();
          return const Placeholder();
        }),
        // body: Text("kkkkk"),
      );
}
