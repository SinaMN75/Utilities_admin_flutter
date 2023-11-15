import 'package:utilities/components/pagination.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/products/product_controller.dart';
import 'package:utilities_admin_flutter/views/widget/image_preview_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({this.userId, super.key});

  final String? userId;

  @override
  Key? get key => const Key("محصولات");

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with ProductController, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    userId = widget.userId;
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return scaffold(
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      appBar: AppBar(
        title: const Text("محصولات"),
        actions: <Widget>[
          if (Core.user.tags!.contains(TagUser.adminProductRead.number)) IconButton(onPressed: create, icon: const Icon(Icons.add_box_outlined, size: 40)),
        ],
      ),
      body: Obx(
        () => state.isLoaded()
            ? SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _filters(),
                    DataTable(
                      columns: <DataColumn>[
                        DataColumn(label: const Text("ردیف").titleLarge()),
                        DataColumn(label: const Text("عکس").titleLarge()),
                        DataColumn(label: const Text("دسته بندی و زیر دسته").titleLarge()),
                        DataColumn(label: const Text("عنوان").titleLarge()),
                        DataColumn(label: const Text("مشخصات").titleLarge()),
                        DataColumn(label: const Text("وضعیت").titleLarge()),
                        DataColumn(label: const Text("تعداد بازدید").titleLarge()),
                        DataColumn(label: const Text("عملیات‌ها").titleLarge()),
                      ],
                      rows: <DataRow>[
                        ...filteredList
                            .mapIndexed(
                              (final int index, final ProductReadDto i) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(index.toString()).bodyLarge().paddingAll(8)),
                                  DataCell(image(i.media.getImage(), width: 32, height: 32).onTap(() {
                                    push(ImagePreviewPage(i.media!.map((final MediaReadDto e) => e.url).toList()));
                                  })),
                                  DataCell(Text(
                                    "${i.categories!.firstWhereOrNull((final CategoryReadDto i) => i.parentId == null)?.title ?? ""} / ${i.categories!.firstWhereOrNull((final CategoryReadDto i) => i.parentId != null)?.title ?? ""}",
                                  ).bodyLarge().paddingAll(8)),
                                  DataCell(Text(i.title ?? "").bodyLarge().paddingAll(8)),
                                  DataCell(Text((i.children ?? <ProductReadDto>[]).map((final ProductReadDto e) => e.title).toList().toString())),
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
                                        if (Core.user.tags!.contains(TagUser.adminProductUpdate.number))
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

  Widget _filters() => Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('عنوان').bodyLarge().marginSymmetric(horizontal: 16),
              const SizedBox(height: 8),
              textField(hintText: "عنوان", controller: controllerTitle).container(width: 300),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('وضعیت').bodyLarge().marginSymmetric(horizontal: 16),
              DropdownButtonFormField<int>(
                value: selectedProductTag.value,
                items: <DropdownMenuItem<int>>[
                  DropdownMenuItem<int>(value: TagProduct.all.number, child: const Text("همه")),
                  DropdownMenuItem<int>(value: TagProduct.released.number, child: const Text("منتشر شده")),
                  DropdownMenuItem<int>(value: TagProduct.notAccepted.number, child: const Text("رد شده")),
                  DropdownMenuItem<int>(value: TagProduct.inQueue.number, child: const Text("در انتظار بررسی")),
                ],
                onChanged: selectedProductTag,
              ).container(width: 200, margin: const EdgeInsets.all(8)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('مجموعه').bodyLarge().marginSymmetric(horizontal: 16),
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
              ).container(width: 250, margin: const EdgeInsets.all(8)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('زیر مجموعه').bodyLarge().marginSymmetric(horizontal: 16),
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
                onChanged: selectedSubCategory,
              ).container(width: 280, margin: const EdgeInsets.all(8)),
            ],
          ),
          Column(
            children: <Widget>[
              const Text(' '),
              button(title: "فیلتر", onTap: read, width: 200),
            ],
          ),
        ],
      );
}
