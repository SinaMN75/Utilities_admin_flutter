import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin AddProductController {
  final Rx<PageState> state = PageState.initial.obs;
  ProductReadDto? dto;
  List<String>? images;
  String? description;
  bool? isFromInstagram;

  List<CroppedFile> files = <CroppedFile>[].obs;
  List<CroppedFile> imageFiles = <CroppedFile>[];
  List<CroppedFile> imageCropFiles = <CroppedFile>[];

  final ProductDataSource _productDataSource = ProductDataSource(baseUrl: AppConstants.baseUrl);
  final RxList<KeyValueViewModel> keyValueList = <KeyValueViewModel>[].obs;
  final RxList<ProductCreateUpdateDto> subProducts = <ProductCreateUpdateDto>[].obs;
  final RxList<ProductCreateUpdateDto> deletedSubProducts = <ProductCreateUpdateDto>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();

  late Rx<CategoryReadDto> selectedCategory;
  late Rx<CategoryReadDto> selectedSubCategory;
  RxList<CategoryReadDto> categories = Core.categories.where((final CategoryReadDto e) => !e.children.isNullOrEmpty()).toList().obs;
  RxList<CategoryReadDto> subCategories = (Core.categories.first.children ?? <CategoryReadDto>[]).obs;

  void init() {
    selectedCategory = categories.first.obs;
    selectedSubCategory = categories.first.children!.first.obs;
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

  void addToImageFile(final List<String> image, final VoidCallback action) async {
    if (count == image.length) {
      action();
    } else {
      // imageFiles.add(await fileFromImageUrl(image[count]));
      count++;
      addToImageFile(image, action);
    }
  }

  void readyProductForEdit() {
    controllerTitle.text = dto!.title ?? "";
    controllerDescription.text = dto!.description ?? "";
    keyValueList(dto!.jsonDetail?.keyValues ?? <KeyValueViewModel>[]);
    subProducts((dto!.children ?? <ProductReadDto>[])
        .map(
          (final ProductReadDto i) => ProductCreateUpdateDto(color: i.jsonDetail?.color, title: i.title, stock: i.stock, price: i.price, id: i.id),
        )
        .toList());
    // state.loaded();
    final List<CategoryReadDto> cats = categories.where((final CategoryReadDto p0) => dto!.categories!.map((final CategoryReadDto e) => e.id).toList().contains(p0.id)).toList();
    final List<CategoryReadDto> subCat = cats.first.children!.where((final CategoryReadDto p0) => dto!.categories!.map((final CategoryReadDto e) => e.id).toList().contains(p0.id)).toList();

    selectedCategory(cats.first);
    selectedSubCategory(subCat.first);

    state.loaded();
  }

  void readyProductFromInstagram() {
    controllerDescription.text = description ?? '';

    state.loaded();
  }

  void selectCategory(final CategoryReadDto? dto) {
    selectedCategory(dto);
    subCategories(categories.singleWhere((final CategoryReadDto e) => e.id == selectedCategory.value.id).children);
    selectedSubCategory(subCategories.where((final CategoryReadDto e) => e.parentId == selectedCategory.value.id).first);
  }

  void selectSubCategory(final CategoryReadDto? dto) {
    selectedSubCategory(dto);
  }

  void createUpdate({required final VoidCallback action}) => validateForm(
        key: formKey,
        action: () {
          if (keyValueList.isEmpty) return snackbarRed(title: s.error, subtitle: "حداقل یک ویژگی وارد کنید");
          if (subProducts.isEmpty) return snackbarRed(title: s.error, subtitle: "حداقل یک نوع محصول با قیمت و موجودی وارد کنید");
          if (dto == null) {
            state.loading();

            final ProductCreateUpdateDto filter = ProductCreateUpdateDto(
              title: controllerTitle.text,
              description: controllerDescription.text,
              categories: <String>[selectedCategory.value.id, selectedSubCategory.value.id],
              children: subProducts,
              price: subProducts.first.price,
              keyValues: keyValueList,
              tags: <int>[TagProduct.physical.number, TagProduct.released.number],
            );
            _productDataSource.create(
              dto: filter,
              onResponse: (final GenericResponse<ProductReadDto> response) async {
                imageCropFiles.forEach((final CroppedFile i) async {
                  if (isWeb) {
                    await GetConnect().post(
                      "https://api.sinamn75.com/api/Media",
                      FormData(<String, dynamic>{
                        'Files': MultipartFile(await i.readAsBytes(), filename: ':).png'),
                        "ProductId": response.result!.id,
                      }),
                      headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
                      contentType: "multipart/form-data",
                    );
                  } else {
                    await GetConnect().post(
                      //
                      "https://api.sinamn75.com/api/Media",
                      FormData(<String, dynamic>{
                        // 'Files': MultipartFile(i.path, filename: ':).png'),
                        'Files': MultipartFile(File(i.path), filename: ':).png'),
                        "ProductId": response.result!.id,
                      }),
                      headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
                      contentType: "multipart/form-data",
                    );
                  }
                });

                imageFiles.clear();
                imageCropFiles.clear();
                keyValueList.clear();
                subProducts.clear();
                controllerTitle.clear();
                controllerDescription.clear();
                state.loaded();
                action();
              },
              onError: (final GenericResponse<dynamic> response) {},
              failure: (final String error) {},
            );
          } else {
            state.loading();
            deletedSubProducts.forEach((final ProductCreateUpdateDto i) {
              if (i.id != null)
                _productDataSource.delete(
                  id: i.id!,
                  onResponse: (final GenericResponse<dynamic> response) {},
                  onError: (final GenericResponse<dynamic> response) {},
                );
            });
            _productDataSource.update(
              dto: ProductCreateUpdateDto(
                id: dto!.id,
                title: controllerTitle.text,
                description: controllerDescription.text,
                categories: <String>[selectedCategory.value.id, selectedSubCategory.value.id],
                children: subProducts,
                price: subProducts.first.price,
                keyValues: keyValueList,
                tags: <int>[TagProduct.physical.number, TagProduct.inQueue.number],
              ),
              onResponse: (final GenericResponse<ProductReadDto> response) {
                (dto?.media ?? <MediaReadDto>[]).forEach((final MediaReadDto element) {
                  final MediaDataSource mediaDataSource = MediaDataSource(baseUrl: AppConstants.baseUrl);
                  mediaDataSource.delete(
                    id: element.id ?? '',
                    onResponse: (final GenericResponse<dynamic> resporse) {},
                    onError: (final GenericResponse<dynamic> errorResponse) {},
                  );
                });

                imageCropFiles.forEach((final CroppedFile i) async {
                  if (isWeb) {
                    await GetConnect().post(
                      "https://api.sinamn75.com/api/Media",
                      FormData(<String, dynamic>{
                        'Files': MultipartFile(await i.readAsBytes(), filename: ':).png'),
                        "ProductId": response.result!.id,
                      }),
                      headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
                      contentType: "multipart/form-data",
                    );
                  } else {
                    await GetConnect().post(
                      //
                      "https://api.sinamn75.com/api/Media",
                      FormData(<String, dynamic>{
                        // 'Files': MultipartFile(i.path, filename: ':).png'),
                        'Files': MultipartFile(File(i.path), filename: ':).png'),
                        "ProductId": response.result!.id,
                      }),
                      headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
                      contentType: "multipart/form-data",
                    );
                  }
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

  Future<File> fileFromImageUrl(final String url) async {
    final http.Response response = await http.get(Uri.parse(url));

    final Directory documentDirectory = await getApplicationDocumentsDirectory();

    final File file = File(join(documentDirectory.path, url.split('/').last));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }

  Future<Uint8List> byteFromImageUrl(final String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  Future<File> byteFromImageUrl2(final String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    final Uint8List tt = response.bodyBytes;
    return File.fromRawPath(tt);
  }
}
