import 'package:utilities/utilities.dart';

mixin UserCreateUpdateController {
  Rx<PageState> state = PageState.initial.obs;

  void init() {}
}
