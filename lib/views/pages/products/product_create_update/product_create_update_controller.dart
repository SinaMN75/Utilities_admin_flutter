import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin ProductCreateUpdateController {
  Rx<PageState> state = PageState.initial.obs;
  ProductReadDto? dto;

  final MediaDataSource mediaDataSource = MediaDataSource(baseUrl: AppConstants.baseUrl);

  late Rx<CategoryReadDto> selectedCategory;
  late Rx<CategoryReadDto> selectedSubCategory;
  RxList<CategoryReadDto> categories = Core.categories.where((final CategoryReadDto e) => !e.children.isNullOrEmpty()).toList().obs;
  RxList<CategoryReadDto> subCategories = (Core.categories.first.children ?? <CategoryReadDto>[]).obs;
  final RxList<KeyValueViewModel> keyValueList = <KeyValueViewModel>[].obs;
  final RxList<ProductCreateUpdateDto> subProducts = <ProductCreateUpdateDto>[ProductCreateUpdateDto(color: "000000")].obs;
  final RxList<ProductCreateUpdateDto> deletedSubProducts = <ProductCreateUpdateDto>[].obs;


  void init() {
    selectedCategory = categories.first.obs;
    selectedSubCategory = categories.first.children!.first.obs;
  }

  void selectCategory(final CategoryReadDto? dto) {
    selectedCategory(dto);
    subCategories(categories.singleWhere((final CategoryReadDto e) => e.id == selectedCategory.value.id).children);
    selectedSubCategory(subCategories.where((final CategoryReadDto e) => e.parentId == selectedCategory.value.id).first);
  }

  void selectSubCategory(final CategoryReadDto? dto) {
    selectedSubCategory(dto);
  }

}
