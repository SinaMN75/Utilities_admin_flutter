import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/transactions/transactions_controller.dart';
import 'package:utilities_admin_flutter/views/widget/table.dart';
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
              icon: const Icon(Icons.add_box_outlined, size: 40),
            ),
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
                        DataColumn(label: Text("خریدار")),
                        DataColumn(label: Text("فروشنده")),
                        DataColumn(label: Text("مبلغ")),
                      ],
                      rows: <DataRow>[
                        ...list
                            .mapIndexed(
                              (final int index, final TransactionReadDto i) => DataRow(
                                color: dataTableRowColor(index),
                                cells: <DataCell>[
                                  DataCell(Text(index.toString())),
                                  DataCell(Text(i.buyer?.appUserName ?? "")),
                                  DataCell(Text(i.seller?.appUserName ?? '*')),
                                  DataCell(Text(getPrice(i.amount ?? 0))),
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

  Widget _filter() => Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          textFieldUser(
            text: "خریدار",
            onUserSelected: (final UserReadDto dto) {
              userId = dto.id;
            },
          ).container(width: 300),
          textFieldUser(
            text: "فروشنده",
            onUserSelected: (final UserReadDto dto) {
              userId = dto.id;
            },
          ).container(width: 300),
          textFieldPersianDatePicker(
            text: "تاریخ شروع",
            controller: controllerStartDate,
            onChange: (final DateTime dateTime, final Jalali jalali) {
              dateTimeStart = dateTime;
              controllerStartDate.text = dateTime.toJalali().formatFullDate();
            },
          ).paddingAll(8).container(width: 300),
          textFieldPersianDatePicker(
            text: "تاریخ پایان",
            controller: controllerEndDate,
            onChange: (final DateTime dateTime, final Jalali jalali) {
              dateTimeEnd = dateTime;
              controllerEndDate.text = dateTime.toJalali().formatFullDate();
            },
          ).paddingAll(8).container(width: 300),
          button(title: "فیلتر", onTap: filter).container(width: 300),
          button(title: "دریافت گزارش", onTap: generateReport).container(width: 300),
        ],
      ).paddingSymmetric(vertical: 8);
}
