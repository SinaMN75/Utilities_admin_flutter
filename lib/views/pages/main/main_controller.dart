import 'package:utilities/utilities.dart';

enum MainPageType {
  dashboard("dashboard"),
  terms("terms"),
  about("about"),
  product("product"),
  category("category"),
  report("report");

  const MainPageType(this.title);

  @override
  String toString() => name;
  final String title;
}

mixin MainController {
  Rx<PageState> state = PageState.initial.obs;
  final Rx<MainPageType> mainPageType = MainPageType.dashboard.obs;

  void init() {}
}
