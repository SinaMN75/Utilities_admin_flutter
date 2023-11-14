import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_controller.dart';
import 'package:utilities_admin_flutter/views/pages/orders/order_detail_page.dart';
import 'package:utilities_admin_flutter/views/pages/tractions/transactions_controller.dart';
import 'package:utilities_admin_flutter/views/pages/users/user_create_update/user_create_update_page.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({ this.userId,super.key});
  final String? userId;

  @override
  Key? get key => const Key("تراکنش ها");

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> with TransactionsController, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    userId=widget.userId;
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return scaffold(
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        appBar: AppBar(
          title: const Text("تراکنش‌ها"),
          actions: <Widget>[
            if (Core.user.tags!.contains(TagUser.adminProductRead.number))
              IconButton(
                  onPressed: () => create(
                        action: filter,
                      ),
                  icon: const Icon(Icons.add_box_outlined, size: 40)),
          ],
        ),
        body: Obx(
          () => state.isLoaded()
              ? Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        textField(
                          text: "عنوان",
                          controller: controllerTitle,
                          onChanged: (final String value) {
                            filter();
                          },
                        ).expanded(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      child: DataTable(
                        columns: <DataColumn>[
                          DataColumn(label: const Text("ردیف").headlineSmall()),
                          DataColumn(label: const Text("عنوان").headlineSmall()),
                          DataColumn(label: const Text("خریدار").headlineSmall()),
                          DataColumn(label: const Text("مبلغ").headlineSmall()),
                          // DataColumn(label: const Text("وضعیت").headlineSmall()),
                        ],
                        rows: <DataRow>[
                          ...filteredList
                              .mapIndexed(
                                (final int index, final TransactionReadDto i) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(index.toString()).bodyLarge().paddingAll(8)),
                                    DataCell(Text(i.descriptions ?? "").bodyLarge().paddingAll(8).onTap(() {
                                      tabWidget.insert(0, OrderDetailPage(orderReadDto: i.order!).container());
                                    })),
                                    DataCell(Text(i.user?.fullName ?? '*').bodyLarge().paddingAll(8).onTap(() {
                                      tabWidget.insert(0, UserCreateUpdatePage(dto: i.user).container());
                                    })),
                                    DataCell(Text(getPrice(i.order?.totalPrice ?? i.amount?? 0)).bodyLarge().paddingAll(8)),
                                  ],
                                ),
                              )
                              .toList(),
                        ],
                      ).container(width: context.width),
                    ).expanded(),
                  ],
                )
              : const CircularProgressIndicator().alignAtCenter(),
        ),
      );
  }
}
