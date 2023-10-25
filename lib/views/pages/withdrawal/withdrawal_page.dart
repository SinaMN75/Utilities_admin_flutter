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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        appBar: AppBar(title: const Text("")),
        body: Obx(
          () => state.isLoaded()
              ? Column(
                  children: <Widget>[
                    const Row(children: <Widget>[Text("data")]),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      child: DataTable(
                        columns: <DataColumn>[
                          DataColumn(label: const Text("ردیف").headlineSmall()),
                          DataColumn(label: const Text("نام کاربر").headlineSmall()),
                          DataColumn(label: const Text("مبلغ").headlineSmall()),
                          DataColumn(label: const Text("شماره‌شبا").headlineSmall()),
                          DataColumn(label: const Text("عملیات‌ها").headlineSmall()),
                        ],
                        rows: <DataRow>[
                          ...filteredList.mapIndexed(
                            (final int index, final WithdrawReadDto i) {
                              final Rx<WithdrawState> selectedState = WithdrawState.requested.obs;
                              if (i.withdrawState == WithdrawState.requested.number) selectedState(WithdrawState.requested);
                              if (i.withdrawState == WithdrawState.accepted.number) selectedState(WithdrawState.accepted);
                              if (i.withdrawState == WithdrawState.rejected.number) selectedState(WithdrawState.rejected);
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(index.toString()).bodyLarge().paddingAll(8)),
                                  DataCell(Text("${i.user?.firstName} ${i.user?.lastName} / ${i.user?.appUserName}").bodyLarge().paddingAll(8)),
                                  DataCell(Text(i.amount.toTomanMoneyPersian()).bodyLarge().paddingAll(8)),
                                  DataCell(
                                    Text(i.shebaNumber).bodyLarge().paddingAll(8).copyTextToClipboardOnTap(
                                          i.shebaNumber,
                                          action: () => snackbarDone(title: "متن کپی شد"),
                                        ),
                                  ),
                                  DataCell(
                                    DropdownButtonFormField<WithdrawState>(
                                      value: selectedState.value,
                                      items: <DropdownMenuItem<WithdrawState>>[
                                        DropdownMenuItem<WithdrawState>(value: WithdrawState.requested, child: Text(WithdrawState.requested.title)),
                                        DropdownMenuItem<WithdrawState>(value: WithdrawState.rejected, child: Text(WithdrawState.rejected.title)),
                                        DropdownMenuItem<WithdrawState>(value: WithdrawState.accepted, child: Text(WithdrawState.accepted.title)),
                                      ],
                                      onChanged: (final WithdrawState? value) => update(dto: WithdrawUpdateDto(id: i.id)),
                                    ).container(width: 150),
                                  ),
                                ],
                              );
                            },
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
