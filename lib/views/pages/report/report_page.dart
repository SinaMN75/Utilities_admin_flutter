import 'package:utilities/data/dto/report.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/report/report_controller.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with ReportController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        constraints: const BoxConstraints(),
        appBar: AppBar(title: const Text("ریپورت‌ها")),
        body: Obx(
          () => state.isLoaded()
              ? Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: DataTable(
                        sortColumnIndex: 0,
                        sortAscending: false,
                        headingRowColor: MaterialStateColor.resolveWith((final Set<MaterialState> states) => context.theme.colorScheme.primaryContainer),
                        headingRowHeight: 60,
                        showCheckboxColumn: false,
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
                                  cells: <DataCell>[
                                    DataCell(Text(index.toString()).bodyLarge().paddingAll(8)),
                                    DataCell(Text(i.title ?? "").bodyLarge().paddingAll(8)),
                                    DataCell(Text(i.description ?? "").bodyLarge().paddingAll(8)),
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
