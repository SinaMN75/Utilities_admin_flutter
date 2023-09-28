import 'package:utilities/components/pagination.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/products/product_controller.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with ProductController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        constraints: const BoxConstraints(),
        appBar: AppBar(
          title: const Text("محصولات"),
          actions: <Widget>[
            IconButton(onPressed: create, icon: const Icon(Icons.add_box_outlined, size: 40)),
          ],
        ),
        body: Obx(
          () => state.isLoaded()
              ? SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          textField(hintText: "عنوان", controller: controllerTitle).container(width: 300),
                          DropdownButtonFormField<int>(
                            value: selectedProductTag.value,
                            items: <DropdownMenuItem<int>>[
                              DropdownMenuItem<int>(value: TagProduct.all.number, child: const Text("همه")),
                              DropdownMenuItem<int>(value: TagProduct.released.number, child: const Text("منتشر شده")),
                              DropdownMenuItem<int>(value: TagProduct.notAccepted.number, child: const Text("رد شده")),
                              DropdownMenuItem<int>(value: TagProduct.inQueue.number, child: const Text("در انتظار بررسی")),
                            ],
                            onChanged: selectedProductTag,
                          ).container(width: 200),
                          DropdownButtonFormField<CategoryReadDto>(
                            value: selectedCategory.value,
                            items: <DropdownMenuItem<CategoryReadDto>>[
                              ...categories
                                  .map(
                                    (final CategoryReadDto e) => DropdownMenuItem<CategoryReadDto>(
                                  value: e,
                                  child: Text(e.title ?? ""),
                                ),
                              )
                                  .toList(),
                            ],
                            onChanged: selectCategory,
                          ).container(width: 200),
                          DropdownButtonFormField<CategoryReadDto>(
                            value: selectedSubCategory.value,
                            items: <DropdownMenuItem<CategoryReadDto>>[
                              ...subCategories
                                  .map(
                                    (final CategoryReadDto e) => DropdownMenuItem<CategoryReadDto>(
                                  value: e,
                                  child: Text(e.title ?? ""),
                                ),
                              )
                                  .toList(),
                            ],
                            onChanged: (final CategoryReadDto? value) {},
                          ).container(width: 200),
                        ],
                      ),
                      button(title: "فیلتر", onTap: read),
                      const SizedBox(height: 20),
                      DataTable(
                        sortColumnIndex: 0,
                        sortAscending: false,
                        headingRowColor: MaterialStateColor.resolveWith((final Set<MaterialState> states) => context.theme.colorScheme.primaryContainer),
                        headingRowHeight: 60,
                        showCheckboxColumn: false,
                        columns: <DataColumn>[
                          DataColumn(label: const Text("ردیف").headlineSmall()),
                          DataColumn(label: const Text("دسته بندی").headlineSmall()),
                          DataColumn(label: const Text("عنوان").headlineSmall()),
                          DataColumn(label: const Text("وضعیت").headlineSmall()),
                          DataColumn(label: const Text("تعداد بازدید").headlineSmall()),
                          DataColumn(label: const Text("عملیات‌ها").headlineSmall()),
                        ],
                        rows: <DataRow>[
                          ...filteredList
                              .mapIndexed(
                                (final int index, final ProductReadDto i) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(index.toString()).bodyLarge().paddingAll(8)),
                                    DataCell(
                                      Text(
                                        "${i.categories!.firstWhereOrNull((final CategoryReadDto i) => i.parentId == null)?.title ?? ""} / ${i.categories!.firstWhereOrNull((final CategoryReadDto i) => i.parentId != null)?.title ?? ""}",
                                      ).bodyLarge().paddingAll(8),
                                    ),
                                    DataCell(Text(i.title ?? "").bodyLarge().paddingAll(8)),
                                    DataCell(Text(UtilitiesTagUtils.tagProductTitleFromTagList(i.tags!)).bodyLarge().paddingAll(8)),
                                    DataCell(
                                      iconTextHorizontal(
                                        leading: const Icon(Icons.remove_red_eye),
                                        trailing: Text((i.visitProducts ?? <ProductInsight>[]).length.toString()).bodyLarge().paddingAll(8),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                            onPressed: () => delete(dto: i),
                                            icon: Icon(Icons.delete, color: context.theme.colorScheme.error),
                                          ).paddingSymmetric(horizontal: 8),
                                          IconButton(
                                            onPressed: () => update(dto: i),
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
                      Pagination(
                        numOfPages: pageCount,
                        selectedPage: pageNumber,
                        pagesVisible: pageCount,
                        onPageChanged: (final int index) {
                          pageNumber = index;
                          read();
                        },
                      ),
                    ],
                  ),
                )
              : const CircularProgressIndicator().alignAtCenter(),
        ),
      );
}
