import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/about/about_page.dart';
import 'package:utilities_admin_flutter/views/pages/categories/category_page.dart';
import 'package:utilities_admin_flutter/views/pages/terms/terms_page.dart';

enum MainPageType {
  dashboard("dashboard"),
  terms("terms"),
  about("about"),
  category("category");

  const MainPageType(this.title);

  @override
  String toString() => name;
  final String title;
}

mixin MainController {
  Rx<PageState> state = PageState.initial.obs;
  final Rx<MainPageType> mainPageType = MainPageType.dashboard.obs;

  void init() {}

  void changePage(final MainPageType type) => mainPageType(type);

  Widget dashboard() => const Scaffold(body: Text("dasboard"));

  Widget about() => const AboutPage();

  Widget terms() => const TermsPage();

  Widget category() => const CategoryPage();

  Widget products() => const Scaffold(body: Text("product"));

  Widget users() => const Scaffold(body: Text("users"));
}
