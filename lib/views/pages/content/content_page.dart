import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/content/content_controller.dart';
import 'package:utilities_admin_flutter/views/widget/table.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  Key? get key => const Key("محتوا");

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> with ContentController, AutomaticKeepAliveClientMixin {
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
      appBar: AppBar(
        actions: <Widget>[
          /// if (Core.user.tags.contains(TagUser.adminContentUpdate.number))
          IconButton(
              onPressed: createUpdate,
              icon: const Icon(Icons.add_box_outlined, size: 40),
            ),
        ],
      ),
      body: Obx(
        () => state.isLoaded()
            ? Column(
                children: <Widget>[
                  DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text("ردیف")),
                      DataColumn(label: Text("تصویر")),
                      DataColumn(label: Text("عنوان")),
                      DataColumn(label: Text("توضیحات")),
                      DataColumn(label: Text("عملیات‌ها")),
                    ],
                    rows: <DataRow>[
                      ...list
                          .mapIndexed(
                            (final int index, final ContentReadDto i) => DataRow(
                              color: dataTableRowColor(index),
                              cells: <DataCell>[
                                DataCell(Text(index.toString())),
                                DataCell(dataTableImage(i.media.getImage() ?? AppImages.logo)),
                                DataCell(Text(i.title ?? "")),
                                DataCell(Text(UtilitiesTagUtils.tagContentFromIntList(i.tags).title)),
                                DataCell(
                                  Row(
                                    children: <Widget>[

                                      /// if (Core.user.tags.contains(TagUser.adminContentUpdate.number))
                                      IconButton(
                                          onPressed: () => delete(dto: i),
                                          icon: Icon(Icons.delete, color: context.theme.colorScheme.error),
                                        ).paddingSymmetric(horizontal: 8),

                                      /// if (Core.user.tags.contains(TagUser.adminContentUpdate.number))
                                      IconButton(
                                          onPressed: () => createUpdate(dto: i),
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
                  ).container(width: double.infinity),
                ],
              )
            : const CircularProgressIndicator().alignAtCenter(),
      ),
    );
  }
}
