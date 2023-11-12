import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_controller.dart';
import 'package:utilities_admin_flutter/views/pages/products/product_create_update/add_product_page.dart';

mixin ProductController {
  Rx<PageState> state = PageState.initial.obs;
late String? userId;
  final RxList<ProductReadDto> list = <ProductReadDto>[].obs;
  final RxList<ProductReadDto> filteredList = <ProductReadDto>[].obs;

  final TextEditingController controllerTitle = TextEditingController();
  final RxInt selectedProductTag = TagProduct.all.number.obs;
  late Rx<CategoryReadDto> selectedCategory;
  Rx<CategoryReadDto> selectedSubCategory = CategoryReadDto(id: '').obs;
  RxList<CategoryReadDto> categories = Core.categories.where((final CategoryReadDto e) => !e.children.isNullOrEmpty()).toList().obs;
  RxList<CategoryReadDto> subCategories = (Core.categories.first.children ?? <CategoryReadDto>[]).obs;
  CategoryReadDto all=CategoryReadDto(id: '',title:'همه');

  int pageNumber = 1;
  int pageCount = 0;

  final ProductDataSource _productDataSource = ProductDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    categories.insert(0, all);
    selectedCategory = categories.first.obs;
    // selectedSubCategory = (categories.first.children ?? <CategoryReadDto>[]).first.obs;
    if (list.isEmpty) {
      read();
    } else {
      state.loaded();
    }
  }

  void selectCategory(final CategoryReadDto? dto) {
    selectedCategory(dto);
    if ((dto?.children ?? <CategoryReadDto>[]).isNotEmpty) {//
      subCategories(categories.singleWhere((final CategoryReadDto e) => e.id == selectedCategory.value.id).children);
      subCategories.insert(0, all);
      selectedSubCategory(subCategories.where((final CategoryReadDto e) => e.parentId == selectedCategory.value.id).first);
    } else {
      subCategories(<CategoryReadDto>[all]);
      selectedSubCategory(subCategories.first);
    }
  }


  void read() {
    state.loading();
    List<int> tags = <int>[
      TagProduct.physical.number,
    ];
    if (selectedProductTag.value != TagProduct.all.number) {
      tags.add(selectedProductTag.value);
    } else {
      tags = <int>[
        TagProduct.physical.number,
      ];
    }

    final List<String> categoryIds = <String>[];
    categoryIds.clear();

    if (selectedSubCategory.value.id != '') {
      categoryIds.add(selectedSubCategory.value.id);
    } else if (selectedCategory.value.id != '') {
      categoryIds.add(selectedCategory.value.id);
    }

    _productDataSource.filter(
      dto: ProductFilterDto(
        userIds: userId!=null?<String>[userId!]:null,
        pageSize: 20,
        pageNumber: pageNumber,
        query: controllerTitle.text,
        categories: categoryIds,
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
        title: "خذف",
        subtitle: "آیا از حذف محصول اطمینان دارید",
        action1: (
          "بله",
          () {
            showEasyLoading();
            _productDataSource.delete(
              id: dto.id,
              onResponse: (final GenericResponse<dynamic> response) {
                snackbarGreen(title: "", subtitle: "حذف محصول ${dto.title} انجام شد");
                list.removeWhere((final ProductReadDto i) => i.id == dto.id);
                filteredList.removeWhere((final ProductReadDto i) => i.id == dto.id);
              },
              onError: (final GenericResponse<dynamic> response) {},
            );
          }
        ),
      );

  void create({final CategoryReadDto? dto}) {
    tabWidget.insert(0, const AddProductPage().container());
  }

  void update({required final ProductReadDto dto}) {
    tabWidget.insert(0, AddProductPage(dto: dto).container());
  }
}
