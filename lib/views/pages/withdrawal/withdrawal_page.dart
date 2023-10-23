import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/withdrawal/withdrawal_controller.dart';

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({super.key});

  @override
  State<WithdrawalPage> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> with WithdrawalController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
    constraints: const BoxConstraints(),
    appBar: AppBar(title: const Text("")),
        body: Obx(
          () => state.isLoaded()
              ? Column(
                  children: <Widget>[
                    const Row(
                      children: <Widget>[
                        Text("data"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      child: DataTable(
                        columns: <DataColumn>[
                          DataColumn(label: const Text("ردیف").headlineSmall()),
                          DataColumn(label: const Text("نام کاربر").headlineSmall()),
                          DataColumn(label: const Text("عنوان انگلیسی").headlineSmall()),
                          DataColumn(label: const Text("عملیات‌ها").headlineSmall()),
                        ],
                        rows: <DataRow>[
                          ...filteredList
                              .mapIndexed(
                                (final int index, final WithdrawReadDto i) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(index.toString()).bodyLarge().paddingAll(8)),
                                    DataCell(Text("${i.user?.firstName} ${i.user?.lastName}").bodyLarge().paddingAll(8)),
                                    DataCell(Text(i.amount.toTomanMoneyPersian()).bodyLarge().paddingAll(8)),
                                    DataCell(
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.edit, color: context.theme.colorScheme.primary),
                                          ).paddingSymmetric(horizontal: 8),
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
