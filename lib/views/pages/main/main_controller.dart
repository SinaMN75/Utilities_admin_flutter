import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/dashboard/dashboard_page.dart';
import 'package:utilities_admin_flutter/views/pages/splash/splash_page.dart';

RxList<Widget> tabWidget = <Widget>[const DashboardPage()].obs;

enum MainPageType {
  dashboard("dashboard"),
  terms("terms"),
  about("about"),
  product("product"),
  comment("comment"),
  productDetail("productDetail"),
  category("category"),
  transaction("transactions"),
  content("content"),
  media("media"),
  order("order"),
  report("report"),
  withdrawal("withdrawal"),
  user("user");

  const MainPageType(this.title);

  @override
  String toString() => name;
  final String title;
}

mixin MainController {
  Rx<PageState> state = PageState.initial.obs;

  void init() {}

  void logout() {
    clearData();
    offAll(const SplashPage());
  }
}
