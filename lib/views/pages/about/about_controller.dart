import 'package:utilities/utilities.dart';

mixin AboutController {
  Rx<PageState> state = PageState.initial.obs;

  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();

  void init() {}
}
