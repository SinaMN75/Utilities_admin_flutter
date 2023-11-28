import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/media/media_controller.dart';
import 'package:utilities_admin_flutter/views/widget/table.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  Key? get key => const Key("فایل‌ها");

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> with MediaController, AutomaticKeepAliveClientMixin {
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
      appBar: AppBar(),
      body: Obx(
        () => state.isLoaded()
            ? Column(
                children: <Widget>[
                  DataTable(
                    dataRowMinHeight: 50,
                    dataRowMaxHeight: 100,
                    columns: const <DataColumn>[DataColumn(label: Text("ردیف")), DataColumn(label: Text("تصویر")), DataColumn(label: Text("عملیات‌ها"))],
                    rows: <DataRow>[
                      ...list
                          .mapIndexed(
                            (final int index, final MediaReadDto i) => DataRow(
                              color: dataTableRowColor(index),
                              cells: <DataCell>[
                                DataCell(Text(index.toString())),
                                DataCell(dataTableImage(i.url, width: 150, height: 150).paddingSymmetric(vertical: 4)),
                                DataCell(IconButton(onPressed: () => _delete(dto: i), icon: Icon(Icons.delete, color: context.theme.colorScheme.error))),
                              ],
                            ),
                          )
                          .toList(),
                    ],
                  ).scrollable().container(width: context.width).expanded(),
                ],
              )
            : const CircularProgressIndicator().alignAtCenter(),
      ),
    );
  }

  void _delete({required final MediaReadDto dto}) => alertDialog(
        title: "خذف",
        subtitle: "آیا از حذف دسته بندی اطمینان دارید",
        action1: ("بله", () => delete(dto: dto)),
      );
}
