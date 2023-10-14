import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/users/user_controller.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with UserController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        constraints: const BoxConstraints(),
        appBar: AppBar(title: const Text("کاربران")),
        body: Obx(
          () => state.isLoaded()
              ? SingleChildScrollView(
                  child: DataTable(
                    columns: <DataColumn>[
                      DataColumn(label: const Text("ردیف").headlineSmall()),
                      DataColumn(label: const Text("نام").headlineSmall()),
                      DataColumn(label: const Text("نام کاربری").headlineSmall()),
                      if (Core.user.tags!.contains(TagUser.adminCategoryUpdate.number)) DataColumn(label: const Text("عملیات").headlineSmall()),
                    ],
                    rows: <DataRow>[
                      ...list
                          .mapIndexed(
                            (final int index, final UserReadDto i) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(index.toString()).bodyLarge().paddingAll(8)),
                                DataCell(Text(i.firstName ?? "").bodyLarge().paddingAll(8)),
                                DataCell(Text(i.appUserName ?? "").bodyLarge().paddingAll(8)),
                                if (Core.user.tags!.contains(TagUser.adminCategoryUpdate.number)) DataCell(IconButton(onPressed: () => edit(i), icon: const Icon(Icons.edit))),
                              ],
                            ),
                          )
                          .toList(),
                    ],
                  ).container(width: context.width).expanded(),
                )
              : const CircularProgressIndicator().alignAtCenter(),
        ),
      );
}
