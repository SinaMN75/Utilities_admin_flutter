import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/report/report_controller.dart';
import 'package:utilities_admin_flutter/views/widget/table.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  Key? get key => const Key("ریپورت ها");

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with ReportController, AutomaticKeepAliveClientMixin {
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
        appBar: AppBar(title: const Text("ریپورت‌ها")),
        body: Obx(
          () => state.isLoaded()
              ? Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: DataTable(
                        columns: <DataColumn>[
                          DataColumn(label: const Text("ردیف").headlineSmall()),
                          DataColumn(label: const Text("عنوان").headlineSmall()),
                          DataColumn(label: const Text("توضیحات").headlineSmall()),
                          DataColumn(label: const Text("محصول").headlineSmall()),
                        ],
                        rows: <DataRow>[
                          ...filteredList
                              .mapIndexed(
                                (final int index, final ReportReadDto i) => DataRow(
                                  color: dataTableRowColor(index),
                                  cells: <DataCell>[
                                    DataCell(Text(index.toString())),
                                    DataCell(Text(i.title ?? "")),
                                    DataCell(Text(i.description ?? "")),
                                    DataCell(TextButton(
                                      onPressed: () {},
                                      child: Text(i.product?.title ?? ""),
                                    ).paddingAll(8)),
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
