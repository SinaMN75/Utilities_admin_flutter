import 'package:utilities/utilities.dart';
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
                          DataColumn(label: const Text("وضعیت").headlineSmall()),
                        ],
                        rows: <DataRow>[
                          ...filteredList
                              .mapIndexed(
                                (final int index, final TransactionReadDto i) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(index.toString()).bodyLarge().paddingAll(8)),
                                    DataCell(Text(i.descriptions ?? "").bodyLarge().paddingAll(8).onTap(() {//
                                      // push(TransactionDetailPage(transactionReadDto: TransactionReadDto()));
                                      // bottomSheet(
                                      //     child: SizedBox(
                                      //   width: screenWidth,
                                      //   child: const Column(
                                      //     children: <Widget>[
                                      //       Icon(Icons.access_time),
                                      //       Icon(Icons.access_time),
                                      //     ],
                                      //   ),
                                      // ));
                                    })),
                                    // DataCell(Text(i.descriptions ?? "").bodyLarge().paddingAll(8)),
                                    DataCell(
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            const Text('وضعیت').bodyLarge().marginSymmetric(horizontal: 16),
                                            DropdownButtonFormField<int>(
                                              value: selectedTransactionTag.value,
                                              items: <DropdownMenuItem<int>>[
                                                DropdownMenuItem<int>(value: TagProduct.all.number, child: const Text("انتخاب")),
                                                DropdownMenuItem<int>(value: TagProduct.released.number, child: const Text("منتشر شده")),
                                                DropdownMenuItem<int>(value: TagProduct.notAccepted.number, child: const Text("رد شده")),
                                                DropdownMenuItem<int>(value: TagProduct.inQueue.number, child: const Text("در انتظار بررسی")),
                                              ],
                                              onChanged: selectedTransactionTag,
                                            ).container(width: 200, margin: const EdgeInsets.all(8)),
                                          ],
                                        ),
                                    ),
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
