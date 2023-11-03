import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_controller.dart';
import 'package:utilities_admin_flutter/views/pages/tractions/transaction_detail_page.dart';
import 'package:utilities_admin_flutter/views/pages/tractions/transactions_controller.dart';
class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> with TransactionsController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        appBar: AppBar(title: const Text("تراکنش‌ها")),
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
                        const SizedBox(width: 20),
                        textField(
                          text: "عنوان انگلیسی",
                          controller: controllerTitleTr1,
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
                          ...filteredList.mapIndexed(
                            (final int index, final TransactionReadDto i) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(index.toString()).bodyLarge().paddingAll(8)),
                                  DataCell(Text(i.descriptions ?? "").bodyLarge().paddingAll(8).onTap(() {
                                    mainWidget(TransactionDetailPage(transactionReadDto: i).container());
                                  })),
                                  DataCell(Text(i.user?.fullName??'*').bodyLarge().paddingAll(8)),
                                  DataCell(Text(getPrice(i.order?.totalPrice??0)).bodyLarge().paddingAll(8)),
                                ],
                              ),
                          ).toList(),
                        ],
                      ).container(width: context.width),
                    ).expanded(),
                  ],
                )
              : const CircularProgressIndicator().alignAtCenter(),
        ),
      );




}
