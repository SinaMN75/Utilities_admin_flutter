import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/users/user_create_update/user_create_update_controller.dart';

class UserCreateUpdatePage extends StatefulWidget {
  const UserCreateUpdatePage({super.key});

  @override
  State<UserCreateUpdatePage> createState() => _UserCreateUpdatePageState();
}

class _UserCreateUpdatePageState extends State<UserCreateUpdatePage> with UserCreateUpdateController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
        appBar: AppBar(title: const Text("")),
        body: const Column(),
      );
}
