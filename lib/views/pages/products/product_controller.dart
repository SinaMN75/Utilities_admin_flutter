import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/products/product_create_update/add_product_page.dart';

mixin ProductController {
  Rx<PageState> state = PageState.initial.obs;
  late String? userId;
  final RxList<ProductReadDto> list = <ProductReadDto>[].obs;
  final RxList<ProductReadDto> filteredList = <ProductReadDto>[].obs;

  final TextEditingController controllerTitle = TextEditingController();
  final RxInt selectedProductStatus = TagProduct.all.number.obs;
  final RxInt selectedProductType = TagProduct.all.number.obs;

  /// late Rx<CategoryReadDto> selectedCategory;
  /// late Rx<CategoryReadDto> selectedSubCategory;
  /// RxList<CategoryReadDto> categories = Core.categories.where((final CategoryReadDto e) => !e.children.isNullOrEmpty()).toList().obs;
  /// RxList<CategoryReadDto> subCategories = (Core.categories.first.children ?? <CategoryReadDto>[]).obs;
  CategoryReadDto all = CategoryReadDto(id: '', title: 'همه', jsonDetail: CategoryJsonDetail(), tags: <int>[]);

  int pageNumber = 1;
  int pageCount = 0;

  final ProductDataSource _productDataSource = ProductDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    ///categories.insert(0, all);
    ///subCategories.insert(0, all);
    ///selectedCategory = categories.first.obs;
    ///selectedSubCategory = subCategories.first.obs;
    if (list.isEmpty) {
      read();
    } else {
      state.loaded();
    }
  }

  /// void selectCategory(final CategoryReadDto? dto) {
  ///   selectedCategory(dto);
  ///   if ((dto?.children ?? <CategoryReadDto>[]).isNotEmpty) {
  ///     subCategories(categories.singleWhere((final CategoryReadDto e) => e.id == selectedCategory.value.id).children);
  ///     subCategories.insert(0, all);
  ///     selectedSubCategory(subCategories.where((final CategoryReadDto e) => e.parentId == selectedCategory.value.id).first);
  ///   } else {
  ///     subCategories(<CategoryReadDto>[all]);
  ///     selectedSubCategory(subCategories.first);
  ///   }
  /// }

  void read() {
    state.loading();
    final List<int> tags = <int>[];
    if (selectedProductStatus.value != TagProduct.all.number) tags.add(selectedProductStatus.value);
    if (selectedProductType.value != TagProduct.all.number) tags.add(selectedProductType.value);

    ///final List<String> categoryIds = <String>[];
    ///categoryIds.clear();

    ///if (selectedSubCategory.value.id != '') {
    ///  categoryIds.add(selectedSubCategory.value.id);
    ///} else if (selectedCategory.value.id != '') {
    ///  categoryIds.add(selectedCategory.value.id);
    ///}

    _productDataSource.filter(
      dto: ProductFilterDto(
        userIds: userId != null ? <String>[userId!] : null,
        pageSize: 20,
        pageNumber: pageNumber,
        query: controllerTitle.text,

        /// categories: categoryIds,
        showCategories: true,
        showChildren: true,
        showMedia: true,
        showVisitProducts: true,
        tags: tags,
      ),
      onResponse: (final GenericResponse<ProductReadDto> response) {
        pageCount = response.pageCount!;
        list(response.resultList);
        filteredList(list);
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void delete({required final ProductReadDto dto}) => alertDialog(
        title: "حذف",
        subtitle: "آیا از حذف محصول اطمینان دارید",
        action1: (
          "بله",
          () {
            showEasyLoading();
            _productDataSource.delete(
              id: dto.id,
              onResponse: (final GenericResponse<dynamic> response) {
                list.removeWhere((final ProductReadDto i) => i.id == dto.id);
                filteredList.removeWhere((final ProductReadDto i) => i.id == dto.id);
                dismissEasyLoading();
                back();
              },
              onError: (final GenericResponse<dynamic> response) {},
            );
          }
        ),
      );

  void create() => dialogAlert(const AddProductPage().container(width: context.width / 1.1));

  void update({required final ProductReadDto dto}) => dialogAlert(AddProductPage(dto: dto).container(width: context.width / 1.1));
}
