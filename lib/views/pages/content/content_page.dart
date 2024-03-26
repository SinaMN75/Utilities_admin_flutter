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
                  _filter(),
                  DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text("ردیف")),
                      DataColumn(label: Text("تصویر")),
                      DataColumn(label: Text("عنوان")),
                      DataColumn(label: Text("توضیحات")),
                      DataColumn(label: Text("عملیات‌ها")),
                    ],
                    rows: <DataRow>[
                      ...filteredList
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
                                      IconButton(
                                        onPressed: () => delete(dto: i),
                                        icon: Icon(Icons.delete, color: context.theme.colorScheme.error),
                                      ).paddingSymmetric(horizontal: 8),
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

  Widget _filter() => Row(
        children: <Widget>[
          DropdownButtonFormField<int>(
            value: selectedContentTag.value,
            items: <DropdownMenuItem<int>>[
              DropdownMenuItem<int>(value: TagContent.all.number, child: const Text("همه")),
              DropdownMenuItem<int>(value: TagContent.aboutUs.number, child: const Text("درباره ما")),
              DropdownMenuItem<int>(value: TagContent.terms.number, child: const Text("قوانین مقررات")),
              DropdownMenuItem<int>(value: TagContent.homeBanner1.number, child: const Text("بنر ۱")),
              DropdownMenuItem<int>(value: TagContent.homeBanner2.number, child: const Text("بنر ۲")),
              DropdownMenuItem<int>(value: TagContent.premium.number, child: const Text("پریمیوم")),
            ],
            onChanged: selectedContentTag,
          ).container(width: 200, margin: const EdgeInsets.all(8)),
          button(title: "فیلتر", onTap: filter, width: 200),
        ],
      ).paddingSymmetric(horizontal: 20, vertical: 20);
}
