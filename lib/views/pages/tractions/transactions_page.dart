import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/orders/order_detail_page.dart';
import 'package:utilities_admin_flutter/views/pages/tractions/transactions_controller.dart';
import 'package:utilities_admin_flutter/views/pages/users/user_create_update/user_create_update_page.dart';
import 'package:utilities_admin_flutter/views/widget/widgets.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({this.userId, super.key});

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
    userId = widget.userId;
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return scaffold(
      constraints: const BoxConstraints(),
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
                  _filter(),
                  SingleChildScrollView(
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text("ردیف")),
                        DataColumn(label: Text("عنوان")),
                        DataColumn(label: Text("خریدار")),
                        DataColumn(label: Text("مبلغ")),
                      ],
                      rows: <DataRow>[
                        ...filteredList
                            .mapIndexed(
                              (final int index, final TransactionReadDto i) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(index.toString())),
                                  DataCell(
                                    Text(i.descriptions ?? "").onTap(
                                      () {
                                        dialogAlert(OrderDetailPage(orderReadDto: i.order!).container(width: context.width / 1.2));
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    Text(i.user?.fullName ?? '*').onTap(
                                      () {
                                        dialogAlert(UserCreateUpdatePage(dto: i.user).container(width: context.width / 1.2));
                                      },
                                    ),
                                  ),
                                  DataCell(Text(getPrice(i.order?.totalPrice ?? i.amount ?? 0))),
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

  Widget _filter() => Row(
        children: <Widget>[
          textFieldUser(
            onUserSelected: (final UserReadDto dto) {
              userId = dto.id;
              filter();
            },
          ).expanded(),
        ],
      ).paddingSymmetric(vertical: 8);
}
