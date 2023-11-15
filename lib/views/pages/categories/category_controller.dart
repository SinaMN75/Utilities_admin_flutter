import 'dart:io';

import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin CategoryController {
  final CategoryDataSource _categoryDataSource = CategoryDataSource(baseUrl: AppConstants.baseUrl);
  final MediaDataSource _mediaDataSource = MediaDataSource(baseUrl: AppConstants.baseUrl);
  Rx<PageState> state = PageState.initial.obs;

  final RxList<CategoryReadDto> list = <CategoryReadDto>[].obs;
  final RxList<CategoryReadDto> filteredList = <CategoryReadDto>[].obs;
  CategoryReadDto? dto;

  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerTitleTr1 = TextEditingController();

  void init() {
    if (dto == null) {
      read();
    } else {
      list(dto?.children);
      filteredList(dto?.children);
      state.loaded();
    }
  }

  void filter() => filteredList(
        list
            .where(
              (final CategoryReadDto i) =>
                  (i.title ?? "").toLowerCase().contains(controllerTitle.text.toLowerCase()) ||
                  (i.titleTr1 ?? "").toLowerCase().contains(
                        controllerTitle.text.toLowerCase(),
                      ),
            )
            .toList(),
      );

  void read() {
    state.loading();
    _categoryDataSource.filter(
      dto: CategoryFilterDto(showMedia: true, tags: <int>[TagCategory.category.number]),
      onResponse: (final GenericResponse<CategoryReadDto> response) {
        list(response.resultList);
        filteredList(list);
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void delete({required final CategoryReadDto dto}) => alertDialog(
        title: "خذف",
        subtitle: "آیا از حذف دسته بندی اطمینان دارید",
        action1: (
          "بله",
          () {
            showEasyLoading();
            _categoryDataSource.delete(
              id: dto.id,
              onResponse: () {
                snackbarGreen(title: "", subtitle: "حذف دسته بندی ${dto.title} انجام شد");
                list.removeWhere((final CategoryReadDto i) => i.id == dto.id);
                filteredList.removeWhere((final CategoryReadDto i) => i.id == dto.id);
                back();
                dismissEasyLoading();
              },
              onError: (final GenericResponse<dynamic> response) {},
            );
          }
        ),
      );

  RxList<String> imageUrls = <String>[].obs;
  Rx<CroppedFile> baseCropFiles = CroppedFile('').obs;
  Rx<CroppedFile> cropFiles = CroppedFile('').obs;

  void create({required final VoidCallback action, final CategoryReadDto? dto}) {
    final TextEditingController controllerTitle = TextEditingController();
    final TextEditingController controllerTitleTr1 = TextEditingController();
    bottomSheet(
      child: column(
        mainAxisSize: MainAxisSize.min,
        height: 500,
        children: <Widget>[
          if (dto != null) Text("زیردسته برای ${dto.title ?? ""}"),
          textField(text: "عنوان", controller: controllerTitle),
          textField(text: "عنوان انگلیسی", controller: controllerTitleTr1),
          const SizedBox(height: 20),
          const Text("افزودن تصویر"),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() => state.isLoaded()
                ? Row(
                    children: <Widget>[
                      if (cropFiles.value.path != '')
                        _items(path: cropFiles.value, originalPath: baseCropFiles.value, action: action).marginSymmetric(horizontal: 4).onTap(
                              () => cropImageCrop(
                                result: (final CroppedFile cropped) {
                                  cropFiles(cropped);
                                  baseCropFiles(cropped);

                                  action();
                                },
                              ),
                            )
                      else
                        Container(
                          child: Icon(Icons.add, size: 60, color: context.theme.dividerColor)
                              .container(
                                radius: 10,
                                borderColor: context.theme.dividerColor,
                                width: 100,
                                height: 100,
                              )
                              .onTap(
                                () => cropImageCrop(
                                  result: (final CroppedFile cropped) {
                                    cropFiles(cropped);
                                    baseCropFiles(cropped);

                                    action();
                                  },
                                ),
                              ),
                        ),
                    ],
                  )
                : const SizedBox()),
          ).marginOnly(bottom: 8),
          button(
            width: 400,
            title: "ثبت",
            onTap: () {
              showEasyLoading();
              _categoryDataSource.create(
                dto: CategoryCreateUpdateDto(
                  title: controllerTitle.text,
                  titleTr1: controllerTitleTr1.text,
                  parentId: dto?.id,
                  tags: <int>[TagCategory.category.number],
                ),
                onResponse: (final GenericResponse<CategoryReadDto> response) {
                  if (isWeb) {
                    GetConnect().post(
                      "https://api.sinamn75.com/api/Media",
                      FormData(<String, dynamic>{
                        'Files': MultipartFile(File(cropFiles.value.path).readAsBytes(), filename: ':).png'),
                        "CategoryId": response.result!.id,
                      }),
                      headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
                      contentType: "multipart/form-data",
                    );
                  } else {
                    GetConnect().post(
                      "https://api.sinamn75.com/api/Media",
                      FormData(<String, dynamic>{
                        'Files': MultipartFile(File(cropFiles.value.path), filename: ':).png'),
                        "CategoryId": response.result!.id,
                      }),
                      headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
                      contentType: "multipart/form-data",
                    );
                  }

                  cropFiles(CroppedFile(''));
                  baseCropFiles(CroppedFile(''));

                  if (dto != null) {
                    filteredList.add(response.result!);
                  } else {
                    list.add(response.result!);
                  }
                  dismissEasyLoading();
                  controllerTitle.clear();
                  back();
                },
                onError: (final GenericResponse<dynamic> response) {},
              );
            },
          ),
        ],
      ),
    );
  }

  void update({required final CategoryReadDto dto, required final int index, required final VoidCallback action}) {
    final TextEditingController controllerTitle = TextEditingController(text: dto.title);
    final TextEditingController controllerTitleTr1 = TextEditingController(text: dto.titleTr1);
    final List<String> listOfDeleteImage = <String>[];
    bottomSheet(
      child: column(
        mainAxisSize: MainAxisSize.min,
        height: 500,
        children: <Widget>[
          if ((dto.media ?? <MediaReadDto>[]).isNotEmpty) image((dto.media.imagesUrl() ?? <String>[]).firstOrNull ?? AppImages.logo),
          textField(text: "عنوان", controller: controllerTitle),
          textField(text: "عنوان انگلیسی", controller: controllerTitleTr1),
          const Text("افزودن تصویر"),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() => state.isLoaded()
                ? Row(
                    children: <Widget>[
                      if (cropFiles.value.path != '')
                        _items(path: cropFiles.value, originalPath: baseCropFiles.value, action: action).marginSymmetric(horizontal: 4).onTap(
                              () => cropImageCrop(
                                result: (final CroppedFile cropped) {
                                  cropFiles(cropped);
                                  baseCropFiles(cropped);

                                  action();
                                },
                              ),
                            )
                      else
                        Container(
                          child: Icon(Icons.add, size: 60, color: context.theme.dividerColor).container(
                            radius: 10,
                            borderColor: context.theme.dividerColor,
                            width: 100,
                            height: 100,
                          ),
                        ),
                    ],
                  )
                : const SizedBox()),
          ).marginOnly(bottom: 18),
          button(
            width: 400,
            title: "ثبت",
            onTap: () {
              showEasyLoading();
              _categoryDataSource.update(
                dto: CategoryCreateUpdateDto(id: dto.id, title: controllerTitle.text, titleTr1: controllerTitleTr1.text),
                onResponse: (final GenericResponse<CategoryReadDto> response) {
                  listOfDeleteImage.forEach((final String element) {
                    _mediaDataSource.delete(
                      id: element,
                      onResponse: (final GenericResponse<dynamic> p0) {},
                      onError: (final GenericResponse<dynamic> errorResponse) {},
                    );
                  });

                  if (isWeb) {
                    GetConnect().post(
                      "https://api.sinamn75.com/api/Media",
                      FormData(<String, dynamic>{
                        'Files': MultipartFile(cropFiles.value.readAsBytes(), filename: ':).png'),
                        "categoryId": response.result!.id,
                      }),
                      headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
                      contentType: "multipart/form-data",
                    );
                  } else {
                    GetConnect().post(
                      "https://api.sinamn75.com/api/Media",
                      FormData(<String, dynamic>{
                        'Files': MultipartFile(File(cropFiles.value.path), filename: ':).png'),
                        "categoryId": response.result!.id,
                      }),
                      headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
                      contentType: "multipart/form-data",
                    );
                  }

                  cropFiles(CroppedFile(''));
                  baseCropFiles(CroppedFile(''));

                  filteredList.removeAt(index);
                  filteredList.insert(index, response.result!);
                  dismissEasyLoading();
                  controllerTitle.clear();
                  back();
                },
                onError: (final GenericResponse<dynamic> response) {},
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _items({required final VoidCallback action, final CroppedFile? path, final CroppedFile? originalPath, final String? url}) => Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Image.network(url ?? path!.path, width: 128, height: 128),
              const Icon(
                Icons.close_outlined,
                size: 18,
                color: Colors.white,
              ).container(width: 22, height: 22, backgroundColor: Colors.red, radius: 50).marginAll(4).onTap(() {
                cropFiles(CroppedFile(''));
                action();
              }),
            ],
          ).marginSymmetric(horizontal: 4).onTap(() {}),
          const SizedBox(height: 8),
          if (originalPath != null)
            SizedBox(
              child: button(
                title: 'کراپ',
                width: 100,
                onTap: () async {
                  final CroppedFile? croppedFile = await ImageCropper().cropImage(
                    sourcePath: originalPath.path,
                    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                    uiSettings: <PlatformUiSettings>[
                      WebUiSettings(context: context, enforceBoundary: true, enableExif: true, enableZoom: true, showZoomer: true),
                    ],
                  );
                  cropFiles(croppedFile);
                  action();
                },
              ),
            )
          else
            const SizedBox(
              height: 40,
            ),
        ],
      );

  void createCategoryFromExcel() => uploadExcel(
        result: (final List<CategoryReadDto> categories) {
          categories.forEach((final CategoryReadDto i) {
            delay(
                100,
                () => _categoryDataSource.create(
                      dto: CategoryCreateUpdateDto(
                        id: i.id,
                        title: i.title,
                        titleTr1: i.titleTr1,
                        parentId: i.parentId != '-' ? i.parentId : null,
                        tags: <int>[TagCategory.category.number],
                        isUnique: true,
                      ),
                      onResponse: (final GenericResponse<CategoryReadDto> response) => state.loaded(),
                      onError: (final GenericResponse<dynamic> response) {},
                    ));
          });
        },
      );

  void uploadExcel({required final Function(List<CategoryReadDto> categories) result}) async {
    final ExcelToJson2 excelToJson = ExcelToJson2();
    await excelToJson.categoryConvert(result: result);
  }
}
