import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin AddProductController {
  final Rx<PageState> state = PageState.initial.obs;
  final RxInt selectedProductStatus = TagProduct.all.number.obs;
  final RxInt selectedProductType = TagProduct.all.number.obs;
  ProductReadDto? dto;
  String? description;
  bool? isFromInstagram;

  List<FileData> deletedFiles = <FileData>[];
  List<FileData> editedFiles = <FileData>[];
  List<FileData> files = <FileData>[];

  final ProductDataSource _productDataSource = ProductDataSource(baseUrl: AppConstants.baseUrl);
  final MediaDataSource _mediaDataSource = MediaDataSource(baseUrl: AppConstants.baseUrl);

  final RxList<KeyValueViewModel> keyValueList = <KeyValueViewModel>[].obs;

  /// final RxList<ProductCreateUpdateDto> subProducts = <ProductCreateUpdateDto>[].obs;
  /// final RxList<ProductCreateUpdateDto> deletedSubProducts = <ProductCreateUpdateDto>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerWebSite = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();

  /// late Rx<CategoryReadDto> selectedCategory;
  /// late Rx<CategoryReadDto> selectedSubCategory;
  /// RxList<CategoryReadDto> categories = Core.categories
  ///     .where(
  ///       (final CategoryReadDto e) => !e.children.isNullOrEmpty(),
  ///     )
  ///     .toList()
  ///     .obs;
  /// RxList<CategoryReadDto> subCategories = (Core.categories.first.children ?? <CategoryReadDto>[]).obs;

  void init() {
    /// selectedCategory = categories.first.obs;
    /// selectedSubCategory = categories.first.children!.first.obs;
    if (isFromInstagram ?? false) {
      readyProductFromInstagram();
    } else if (dto == null) {
      state.loaded();
    } else {
      readyProductForEdit();
    }
  }

  int count = 0;

  void getProductById({final String? id}) {
    if (id != null) {
      _productDataSource.readById(
        id: id,
        onResponse: (final GenericResponse<ProductReadDto> response) {
          dto = response.result;
        },
        onError: (final GenericResponse<dynamic> errorResponse) {},
      );
    }
  }

  void readyProductForEdit() {
    controllerTitle.text = dto!.title ?? "";
    controllerDescription.text = dto!.description ?? "";

    keyValueList(dto!.jsonDetail.keyValues ?? <KeyValueViewModel>[]);

    /// subProducts((dto!.children ?? <ProductReadDto>[])
    ///     .map(
    ///      (final ProductReadDto i) => ProductCreateUpdateDto(
    ///        color: i.jsonDetail?.color,
    ///        title: i.title,
    ///        stock: i.stock,
    ///        price: i.price,
    ///        id: i.id,
    ///        tags: <int>[],
    ///      ),
    ///    )
    ///    .toList());
    /// final List<CategoryReadDto> cats = categories
    ///     .where(
    ///       (final CategoryReadDto p0) => dto!.categories!.map((final CategoryReadDto e) => e.id).toList().contains(p0.id),
    ///     )
    ///     .toList();
    /// final List<CategoryReadDto> subCat = cats.first.children!
    ///     .where(
    ///       (final CategoryReadDto p0) => dto!.categories!.map((final CategoryReadDto e) => e.id).toList().contains(p0.id),
    ///     )
    ///     .toList();
    /// selectedCategory(cats.first);
    /// selectedSubCategory(subCat.first);

    state.loaded();
  }

  void readyProductFromInstagram() {
    controllerDescription.text = description ?? '';

    state.loaded();
  }

  /// void selectCategory(final CategoryReadDto? dto) {
  ///   selectedCategory(dto);
  ///   subCategories(categories.singleWhere((final CategoryReadDto e) => e.id == selectedCategory.value.id).children);
  ///   selectedSubCategory(subCategories.where((final CategoryReadDto e) => e.parentId == selectedCategory.value.id).first);
  /// }
  ///
  /// void selectSubCategory(final CategoryReadDto? dto) {
  ///   selectedSubCategory(dto);
  /// }

  void createUpdate({required final VoidCallback action}) => validateForm(
        key: formKey,
        action: () {
          /// if (keyValueList.isEmpty) return snackbarRed(title: s.error, subtitle: "حداقل یک ویژگی وارد کنید");
          /// if (subProducts.isEmpty)
          ///   return snackbarRed(
          ///     title: s.error,
          ///     subtitle: "حداقل یک نوع محصول با قیمت و موجودی وارد کنید",
          ///   );
          if (dto == null) {
            state.loading();
            final ProductCreateUpdateDto createDto = ProductCreateUpdateDto(
              title: controllerTitle.text,
              description: controllerDescription.text,

              /// categories: <String>[selectedCategory.value.id, selectedSubCategory.value.id],
              /// children: subProducts,
              /// price: subProducts.first.price,
              keyValues: keyValueList,
              website: controllerWebSite.text,
              tags: <int>[selectedProductType.value, selectedProductStatus.value],
            );
            _productDataSource.create(
              dto: createDto,
              onResponse: (final GenericResponse<ProductReadDto> response) async {
                Core.fileUploadingCount(Core.fileUploadingCount.value += files.length);
                await Future.forEach(files, (final FileData i) async {
                  if (i.parentId == null)
                    await _mediaDataSource.create(
                      parentId: i.parentId,
                      fileData: i,
                      id: i.id,
                      fileExtension: i.extension!,
                      productId: response.result?.id,
                      tags: <int>[TagMedia.image.number],
                      onResponse: () => Core.fileUploadingCount(Core.fileUploadingCount.value - 1),
                      onError: () {},
                    );
                });
                await Future.forEach(files, (final FileData i) async {
                  if (i.parentId != null)
                    await _mediaDataSource.create(
                      parentId: i.parentId,
                      id: i.id,
                      fileData: i,
                      fileExtension: i.extension!,
                      productId: response.result?.id,
                      tags: <int>[TagMedia.image.number],
                      onResponse: () => Core.fileUploadingCount(Core.fileUploadingCount.value - 1),
                      onError: () {},
                    );
                });
                state.loaded();
                action();
              },
              onError: (final GenericResponse<dynamic> response) {},
              failure: (final String error) {},
            );
          } else {
            state.loading();

            /// deletedSubProducts.forEach((final ProductCreateUpdateDto i) {
            ///   if (i.id != null)
            ///     _productDataSource.delete(
            ///       id: i.id!,
            ///       onResponse: (final GenericResponse<dynamic> response) {},
            ///       onError: (final GenericResponse<dynamic> response) {},
            ///     );
            /// });
            _productDataSource.update(
              dto: ProductCreateUpdateDto(
                id: dto!.id,
                title: controllerTitle.text,
                description: controllerDescription.text,

                /// categories: <String>[selectedCategory.value.id, selectedSubCategory.value.id],
                /// children: subProducts,
                /// price: subProducts.first.price,
                keyValues: keyValueList,
                tags: <int>[selectedProductStatus.value, selectedProductType.value],
              ),
              onResponse: (final GenericResponse<ProductReadDto> response) {
                deletedFiles.forEach((final FileData i) {
                  _mediaDataSource.delete(id: i.id!, onResponse: () {}, onError: () {});
                });
                editedFiles.forEach((final FileData i) {
                  _mediaDataSource.update(
                    dto: MediaUpdateDto(
                      id: i.id,
                      title: i.jsonDetail?.title,
                      link2: i.jsonDetail?.link2,
                      description: i.jsonDetail?.description,
                      time: i.jsonDetail?.time,
                      size: i.jsonDetail?.size,
                      order: i.order,
                      tags: i.tags,
                      link1: i.jsonDetail?.link1,
                      link3: i.jsonDetail?.link3,
                      album: i.jsonDetail?.album,
                      artist: i.jsonDetail?.artist,
                    ),
                    onResponse: (final GenericResponse<MediaReadDto> response) {},
                    onError: (final GenericResponse<dynamic> response) {},
                  );
                });
                Core.fileUploadingCount(Core.fileUploadingCount.value += files.length);
                files.forEach((final FileData i) async {
                  await _mediaDataSource.create(
                    fileData: i,
                    parentId: i.parentId,
                    fileExtension: i.extension!,
                    productId: response.result?.id,
                    tags: <int>[TagMedia.image.number],
                    onResponse: () => Core.fileUploadingCount(Core.fileUploadingCount.value - 1),
                    onError: () {},
                  );
                });
                state.loaded();
                action();
                back();
              },
              onError: (final GenericResponse<dynamic> response) {},
            );
          }
        },
      );
}
