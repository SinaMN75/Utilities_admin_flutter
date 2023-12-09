import 'package:utilities/components/pagination.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/users/user_controller.dart';
import 'package:utilities_admin_flutter/views/widget/table.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  Key? get key => const Key("کاربران");

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with UserController, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return scaffold(
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        const DataColumn(label: Text("ردیف")),
                        const DataColumn(label: Text("عکس")),
                        const DataColumn(label: Text("نام")),
                        const DataColumn(label: Text("نام خانوادگی")),
                        const DataColumn(label: Text("نام کاربری")),
                        const DataColumn(label: Text("آیدی اینستاگرام")),
                        const DataColumn(label: Text("شماره موبایل")),
                        const DataColumn(label: Text("وضعیت")),
                        if (Core.user.tags!.contains(TagUser.adminCategoryUpdate.number)) const DataColumn(label: Text("عملیات")),
                      ],
                      rows: <DataRow>[
                        ...list
                            .mapIndexed(
                              (final int index, final UserReadDto i) => DataRow(
                                color: dataTableRowColor(index),
                                cells: <DataCell>[
                                  DataCell(Text(index.toString())),
                                  DataCell(dataTableImage(i.media.getImage() ?? AppImages.logo)),
                                  DataCell(Text(i.firstName ?? "--")),
                                  DataCell(Text(i.lastName ?? "--")),
                                  DataCell(Text(i.appUserName ?? "--")),
                                  DataCell(Text(i.jsonDetail?.instagram ?? "--")),
                                  DataCell(Text(i.phoneNumber ?? "--")),
                                  DataCell(
                                    (i.suspend ?? false)
                                        ? const Icon(Icons.power_settings_new_outlined, color: Colors.green)
                                        : const Icon(
                                            Icons.power_settings_new_outlined,
                                            color: Colors.green,
                                          ),
                                  ),
                                  if (Core.user.tags!.contains(TagUser.adminCategoryUpdate.number))
                                    DataCell(
                                      PopupMenuButton<int>(
                                        child: const Icon(Icons.menu),
                                        itemBuilder: (final BuildContext context) => <PopupMenuItem<int>>[
                                          PopupMenuItem<int>(value: 0, child: const Text("ویرایش").bodyMedium()),
                                          PopupMenuItem<int>(value: 1, child: const Text("تراکنش‌ها").bodyMedium()),
                                          PopupMenuItem<int>(value: 2, child: const Text("سفارشات").bodyMedium()),
                                          PopupMenuItem<int>(value: 3, child: const Text("محصولات").bodyMedium()),
                                          PopupMenuItem<int>(value: 4, child: const Text("کامنت‌ها").bodyMedium()),
                                        ],
                                        onSelected: (final int value) {
                                          if (value == 0) edit(i);
                                          if (value == 1) showTransactions(i);
                                          if (value == 2) showOrders(i);
                                          if (value == 3) showProducts(i);
                                          if (value == 4) showComments(i);
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            )
                            .toList(),
                      ],
                    ).container(width: context.width - 200),
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
  }

  Widget _filters() => Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          textField(labelText: "نام", controller: controllerFirstName).container(width: 200, padding: const EdgeInsets.symmetric(horizontal: 4)),
          textField(labelText: "نام خانوادگی", controller: controllerLastName).container(width: 200, padding: const EdgeInsets.symmetric(horizontal: 4)),
          textField(labelText: "شماره موبایل", controller: controllerPhoneNumber).container(width: 200, padding: const EdgeInsets.symmetric(horizontal: 4)),
          textField(labelText: "نام کاربری", controller: controllerUserName).container(width: 200, padding: const EdgeInsets.symmetric(horizontal: 4)),
          DropdownButtonFormField<bool>(
            value: suspend.value,
            items: const <DropdownMenuItem<bool>>[
              DropdownMenuItem<bool>(value: false, child: Text("فعال")),
              DropdownMenuItem<bool>(value: true, child: Text("غیر فعال")),
            ],
            onChanged: suspend,
          ).container(width: 200, margin: const EdgeInsets.symmetric(horizontal: 4)),
          button(title: "فیلتر", onTap: filter, width: 200).paddingSymmetric(horizontal: 4),
        ],
      ).paddingSymmetric(vertical: 4);
}
