import 'package:utilities/components/pagination.dart';
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _filters(),
                      DataTable(
                        columns: <DataColumn>[
                          DataColumn(label: const Text("ردیف").headlineSmall()),
                          DataColumn(label: const Text("نام").headlineSmall()),
                          DataColumn(label: const Text("نام خانوادگی").headlineSmall()),
                          DataColumn(label: const Text("شماره موبایل").headlineSmall()),
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
                                    DataCell(Text(i.lastName ?? "").bodyLarge().paddingAll(8)),
                                    DataCell(Text(i.appUserName ?? "").bodyLarge().paddingAll(8)),
                                    DataCell(Text(i.phoneNumber ?? "").bodyLarge().paddingAll(8)),
                                    if (Core.user.tags!.contains(TagUser.adminCategoryUpdate.number))
                                      DataCell(
                                        IconButton(onPressed: () => edit(i), icon: const Icon(Icons.edit)),
                                      ),
                                  ],
                                ),
                              )
                              .toList(),
                        ],
                      ).container(width: context.width),
                      Pagination(
                        numOfPages: pageCount,
                        selectedPage: pageNumber,
                        pagesVisible: pageCount,
                        onPageChanged: (final int index) {
                          pageNumber = index;
                          filter();
                        },
                      ),
                    ],
                  ),
                )
              : const CircularProgressIndicator().alignAtCenter(),
        ),
      );

  Widget _filters() => Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      textField(hintText: "نام", controller: controllerFirstName).container(width: 300, padding: const EdgeInsets.symmetric(horizontal: 4)),
      textField(hintText: "نام خانوادگی", controller: controllerLastName).container(width: 300, padding: const EdgeInsets.symmetric(horizontal: 4)),
      textField(hintText: "شماره موبایل", controller: controllerPhoneNumber).container(width: 300, padding: const EdgeInsets.symmetric(horizontal: 4)),
      textField(hintText: "نام کاربری", controller: controllerUserName).container(width: 300, padding: const EdgeInsets.symmetric(horizontal: 4)),
      button(title: "فیلتر", onTap: filter, width: 200),
    ],
  ).paddingSymmetric(vertical: 4);
}
