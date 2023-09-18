import 'package:utilities/utilities.dart';

mixin DashboardController {
  Rx<PageState> state = PageState.initial.obs;

  void init() {}
}
