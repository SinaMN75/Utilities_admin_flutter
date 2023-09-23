import 'package:utilities/utilities.dart';

mixin AboutController {
  Rx<PageState> state = PageState.initial.obs;

  late ContentReadDto contentReadDto;

  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();

  void init() {}
}
