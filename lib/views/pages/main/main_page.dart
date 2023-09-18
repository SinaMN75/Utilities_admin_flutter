import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_controller.dart';

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
            if (item.route == MainPageType.dashboard.title) changePage(MainPageType.dashboard);
            if (item.route == MainPageType.about.title) changePage(MainPageType.about);
            if (item.route == MainPageType.terms.title) changePage(MainPageType.terms);
            if (item.route == MainPageType.category.title) changePage(MainPageType.category);
          },
          selectedRoute: '',
        ),
        body: Obx(() {
          if (mainPageType.value == MainPageType.dashboard) return dashboard();
          if (mainPageType.value == MainPageType.terms) return terms();
          if (mainPageType.value == MainPageType.about) return about();
          if (mainPageType.value == MainPageType.category) return category();
          return const Placeholder();
        }),
        // body: Text("kkkkk"),
      );
}
