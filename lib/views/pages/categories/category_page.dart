import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/categories/category_controller.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_controller.dart';
import 'package:utilities_admin_flutter/views/widget/image_preview_page.dart';

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
  Widget build(final BuildContext context) => scaffold(
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        appBar: AppBar(
          title: dto == null ? const Text("دسته بندی‌ها") : Text("زیر دسته های ${dto?.title}"),
          actions: <Widget>[
            if (Core.user.tags!.contains(TagUser.adminCategoryRead.number))  IconButton(
                onPressed: () => create(
                      dto: widget.dto,
                      action: () => setState(() {}), //
                    ),
                icon: const Icon(Icons.add_box_outlined, size: 40)),
            IconButton(onPressed: createCategoryFromExcel, icon: const Icon(Icons.upload, size: 40)),
          ],
        ),
        body: Obx(
          () => state.isLoaded()
              ? Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        textField(
                          text: "عنوان",
                          controller: controllerTitle,
                          onChanged: (final String value) => filter(),
                        ).expanded(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      child: DataTable(
                        columns: <DataColumn>[
                          DataColumn(label: const Text("ردیف").headlineSmall()),
                          DataColumn(label: const Text("عنوان").headlineSmall()),
                          DataColumn(label: const Text("عنوان انگلیسی").headlineSmall()),
                          DataColumn(label: const Text("عملیات‌ها").headlineSmall()),
                        ],
                        rows: <DataRow>[
                          ...filteredList
                              .mapIndexed(
                                (final int index, final CategoryReadDto i) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(index.toString()).bodyLarge().paddingAll(8)),
                                    DataCell(Row(
                                      children: <Widget>[
                                        image(i.media.getImage(), width: 32, height: 32).onTap(() {
                                          push(ImagePreviewPage(i.media!.map((final MediaReadDto e) => e.url).toList()));
                                        }),
                                        Text(i.title ?? "").bodyLarge().paddingAll(8),
                                      ],
                                    )),
                                    DataCell(Text(i.titleTr1 ?? "").bodyLarge().paddingAll(8)),
                                    DataCell(
                                      Row(
                                        children: <Widget>[
                                          if (Core.user.tags!.contains(TagUser.adminCategoryUpdate.number))
                                            IconButton(
                                              onPressed: () => delete(dto: i),
                                              icon: Icon(Icons.delete, color: context.theme.colorScheme.error),
                                            ).paddingSymmetric(horizontal: 8),
                                          if (Core.user.tags!.contains(TagUser.adminCategoryUpdate.number))
                                            IconButton(
                                              onPressed: () => update(dto: i, index: index, action: () {}),
                                              icon: Icon(Icons.edit, color: context.theme.colorScheme.primary),
                                            ).paddingSymmetric(horizontal: 8),
                                          if (dto == null)
                                            TextButton(
                                              onPressed: () => tabWidget.insert(0, CategoryPage(dto: i)),
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
                      ).container(width: context.width),
                    ).expanded(),
                  ],
                )
              : const CircularProgressIndicator().alignAtCenter(),
        ),
      );
}
