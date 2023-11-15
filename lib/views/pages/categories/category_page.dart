import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/categories/category_controller.dart';
import 'package:utilities_admin_flutter/views/widget/table.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, this.dto});

  @override
  Key? get key => const Key("دسته بندی ها");
  final CategoryReadDto? dto;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with CategoryController, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    if (widget.dto != null) dto = widget.dto;
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return scaffold(
      constraints: const BoxConstraints(),
      appBar: AppBar(
        title: dto == null ? const Text("دسته بندی‌ها") : Text("زیر دسته های ${dto?.title}"),
        actions: <Widget>[
          if (Core.user.tags!.contains(TagUser.adminCategoryRead.number)) IconButton(onPressed: () => create(dto: widget.dto), icon: const Icon(Icons.add_box_outlined, size: 40)),
          if (dto == null) IconButton(onPressed: createCategoryFromExcel, icon: const Icon(Icons.upload, size: 40)),
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
                      DataColumn(label: Text("عنوان انگلیسی")),
                      DataColumn(label: Text("عملیات‌ها")),
                    ],
                    rows: <DataRow>[
                      ...filteredList
                          .mapIndexed(
                            (final int index, final CategoryReadDto i) => DataRow(
                              color: dataTableRowColor(index),
                              cells: <DataCell>[
                                DataCell(Text(index.toString())),
                                DataCell(dataTableImage(i.media.getImage())),
                                DataCell(Text(i.title ?? "")),
                                DataCell(Text(i.titleTr1 ?? "")),
                                DataCell(
                                  Row(
                                    children: <Widget>[
                                      if (Core.user.tags!.contains(TagUser.adminCategoryUpdate.number))
                                        IconButton(
                                          onPressed: () => _delete(dto: i),
                                          icon: Icon(Icons.delete, color: context.theme.colorScheme.error),
                                        ).paddingSymmetric(horizontal: 8),
                                      if (Core.user.tags!.contains(TagUser.adminCategoryUpdate.number))
                                        IconButton(
                                          onPressed: () => update(dto: i),
                                          icon: Icon(Icons.edit, color: context.theme.colorScheme.primary)
                                        ).paddingSymmetric(horizontal: 8),
                                      if (dto == null)
                                        TextButton(
                                          onPressed: () => dialogAlert(CategoryPage(dto: i).container(width: context.width)),
                                          child: const Text("نمایش زیر دسته‌ها"),
                                        ).paddingSymmetric(horizontal: 8),
                                    ],
                                  ),
                                ),
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

  Widget _filter() => Row(
        children: <Widget>[
          textField(labelText: "عنوان", controller: controllerTitle, onChanged: (final String value) => filter()).expanded(),
        ],
      ).paddingSymmetric(horizontal: 20, vertical: 20);

  void _delete({required final CategoryReadDto dto}) => alertDialog(
        title: "خذف",
        subtitle: "آیا از حذف دسته بندی اطمینان دارید",
        action1: ("بله", () => delete(dto: dto)),
      );
}
