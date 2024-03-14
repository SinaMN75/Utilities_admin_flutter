import 'package:utilities/components/pagination.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/products/product_controller.dart';
import 'package:utilities_admin_flutter/views/widget/table.dart';

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
        actions: <Widget>[
          ///if (Core.user.tags.contains(TagUser.adminProductRead.number))
          IconButton(onPressed: create, icon: const Icon(Icons.add_box_outlined)),
        ],
      ),
      body: Obx(
        () => state.isLoaded()
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _filters(),
                    DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text("ردیف")),
                        DataColumn(label: Text("عکس")),

                        /// DataColumn(label: Text("دسته بندی")),
                        DataColumn(label: Text("عنوان")),

                        /// DataColumn(label: Text("مشخصات")),
                        DataColumn(label: Text("وضعیت")),
                        DataColumn(label: Text("تعدادبازدید")),
                        DataColumn(label: Text("عملیات‌ها")),
                      ],
                      rows: <DataRow>[
                        ...filteredList
                            .mapIndexed(
                              (final int index, final ProductReadDto i) => DataRow(
                                color: dataTableRowColor(index),
                                cells: <DataCell>[
                                  DataCell(Text(index.toString())),
                                  DataCell(dataTableImage(i.media.getImage() ?? AppImages.logo)),

                                  /// DataCell(
                                  ///   Text(
                                  ///     "${i.categories!.firstWhereOrNull((final CategoryReadDto i) => i.parentId == null)?.title ?? ""} / ${i.categories!.firstWhereOrNull((final CategoryReadDto i) => i.parentId != null)?.title ?? ""}",
                                  ///   ),
                                  /// ),
                                  DataCell(Text(i.title ?? "")),

                                  ///DataCell(Text((i.children ?? <ProductReadDto>[]).map((final ProductReadDto e) => e.title).toList().toString())),
                                  DataCell(Text(UtilitiesTagUtils.tagProductTitleFromTagList(i.tags))),
                                  DataCell(
                                    iconTextHorizontal(
                                      leading: const Icon(Icons.remove_red_eye),
                                      trailing: Text((i.visitProducts ?? <ProductInsight>[]).length.toString()),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: <Widget>[
                                        if (Core.user.tags.contains(TagUser.adminProductUpdate.number))
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
          textField(text: "عنوان", controller: controllerTitle).container(width: 300, margin: const EdgeInsets.only(bottom: 12)),

          /// textFieldUser(onUserSelected: (final UserReadDto dto) => userId = dto.id, text: "شماره همراه کاربر"),
          iconTextVertical(
            crossAxisAlignment: CrossAxisAlignment.start,
            leading: const Text('وضعیت').bodyMedium(),
            trailing: DropdownButtonFormField<int>(
              value: selectedProductStatus.value,
              items: <DropdownMenuItem<int>>[
                DropdownMenuItem<int>(value: TagProduct.all.number, child: const Text("همه")),
                DropdownMenuItem<int>(value: TagProduct.released.number, child: const Text("منتشر شده")),
                DropdownMenuItem<int>(value: TagProduct.notAccepted.number, child: const Text("رد شده")),
                DropdownMenuItem<int>(value: TagProduct.inQueue.number, child: const Text("در انتظار بررسی")),
              ],
              onChanged: selectedProductStatus,
            ).container(width: 200),
          ).paddingSymmetric(horizontal: 8),
          iconTextVertical(
            crossAxisAlignment: CrossAxisAlignment.start,
            leading: const Text('نوع').bodyMedium(),
            trailing: DropdownButtonFormField<int>(
              value: selectedProductType.value,
              items: <DropdownMenuItem<int>>[
                DropdownMenuItem<int>(value: TagProduct.all.number, child: const Text("همه")),
                DropdownMenuItem<int>(value: TagProduct.book.number, child: const Text("کتاب")),
                DropdownMenuItem<int>(value: TagProduct.journal.number, child: const Text("ژورنال")),
                DropdownMenuItem<int>(value: TagProduct.video.number, child: const Text("ویدیو")),
                DropdownMenuItem<int>(value: TagProduct.news.number, child: const Text("اخبار")),
                DropdownMenuItem<int>(value: TagProduct.product.number, child: const Text("محصول")),
                DropdownMenuItem<int>(value: TagProduct.link.number, child: const Text("لینک")),
              ],
              onChanged: selectedProductType,
            ).container(width: 200),
          ).paddingSymmetric(horizontal: 8),

          /// iconTextVertical(
          ///   crossAxisAlignment: CrossAxisAlignment.start,
          ///   leading: const Text('دسته').bodyMedium(),
          ///   trailing: DropdownButtonFormField<CategoryReadDto>(
          ///     value: selectedCategory.value,
          ///     items: <DropdownMenuItem<CategoryReadDto>>[
          ///       ...categories
          ///           .map(
          ///             (final CategoryReadDto e) => DropdownMenuItem<CategoryReadDto>(value: e, child: Text(e.title ?? "")),
          ///           )
          ///           .toList(),
          ///     ],
          ///     onChanged: selectCategory,
          ///   ).container(width: 280),
          /// ).paddingSymmetric(horizontal: 8),
          /// iconTextVertical(
          ///   crossAxisAlignment: CrossAxisAlignment.start,
          ///   leading: const Text('زیر دسته').bodyMedium(),
          ///   trailing: DropdownButtonFormField<CategoryReadDto>(
          ///     value: selectedSubCategory.value,
          ///     items: <DropdownMenuItem<CategoryReadDto>>[
          ///       ...subCategories
          ///           .map(
          ///             (final CategoryReadDto e) => DropdownMenuItem<CategoryReadDto>(
          ///               value: e,
          ///               child: Text(e.title ?? ""),
          ///             ),
          ///           )
          ///           .toList(),
          ///     ],
          ///     onChanged: selectedSubCategory,
          ///   ).container(width: 280),
          /// ).paddingSymmetric(horizontal: 8),
          button(title: "فیلتر", onTap: read, width: 200).paddingOnly(top: 24),
        ],
      );
}
