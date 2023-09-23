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
          title: const Text("دسته بندی‌ها"),
          actions: <Widget>[
            IconButton(onPressed: create, icon: const Icon(Icons.add_box_outlined, size: 40)),
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
                          onChanged: (final String value) {
                            filter();
                          },
                        ).expanded(),
                        const SizedBox(width: 20),
                        textField(
                          text: "عنوان انگلیسی",
                          controller: controllerTitleTr1,
                          onChanged: (final String value) {
                            filter();
                          },
                        ).expanded(),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                          DataColumn(label: const Text("عملیات‌ها").headlineSmall()),
                          DataColumn(label: const Text("وضعیت").headlineSmall()),
                        ],
                        rows: <DataRow>[
                          ...filteredList
                              .mapIndexed(
                                (final int index, final ProductReadDto i) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(index.toString()).bodyLarge().paddingAll(8)),
                                    DataCell(Text(i.title ?? "").bodyLarge().paddingAll(8)),
                                    DataCell(
                                      Text(UtilitiesTagUtils.tagProductTitleFromTagList(i.tags!)).bodyLarge().paddingAll(8),
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
                                          if (!i.children.isNullOrEmpty())
                                            TextButton(
                                              onPressed: () => push(const ProductPage()),
                                              child: const Text("نمایش زیر دسته"),
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
