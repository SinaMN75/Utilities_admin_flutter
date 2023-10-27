import 'dart:io';

import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/widget/image_preview_page.dart';

mixin CategoryController {
  Rx<PageState> state = PageState.initial.obs;

  final RxList<CategoryReadDto> list = <CategoryReadDto>[].obs;
  final RxList<CategoryReadDto> filteredList = <CategoryReadDto>[].obs;
  CategoryReadDto? dto;

  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerTitleTr1 = TextEditingController();

  final CategoryDataSource _categoryDataSource = CategoryDataSource(baseUrl: AppConstants.baseUrl);

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
                  (i.title ?? "").toLowerCase().contains(controllerTitle.text.toLowerCase()) &&
                  (i.titleTr1 ?? "").toLowerCase().contains(
                        controllerTitleTr1.text.toLowerCase(),
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
              },
              onError: (final GenericResponse<dynamic> response) {},
            );
          }
        ),
      );

  RxList<CroppedFile> imageFiles = <CroppedFile>[].obs;
  RxList<CroppedFile> imageCropFiles = <CroppedFile>[].obs;

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
                      ...imageCropFiles.mapIndexed((final int index, final CroppedFile item) => _items(path: item, originalPath: imageFiles[index],
                          index: index, action: action).marginSymmetric(horizontal: 4)).toList(),
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
                                  imageFiles.add(cropped);
                                  imageCropFiles.add(cropped);

                                  action();
                                  debugPrint("DDDD");
                                  // cropperCropFiles.add(cropped);
                                  // result(cropperFiles);
                                },
                              ),
                            ),
                      ),
                    ],
                  )
                : const SizedBox()),
          ),
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
                  imageCropFiles.forEach((final CroppedFile i) async {
                    if (isWeb) {
                      await GetConnect().post(
                        "https://api.sinamn75.com/api/Media",
                        FormData(<String, dynamic>{
                          'Files': MultipartFile(await i.readAsBytes(), filename: ':).png'),
                          "categoryId": response.result!.id,
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
                          "categoryId": response.result!.id,
                        }),
                        headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
                        contentType: "multipart/form-data",
                      );
                    }
                  });

                  imageFiles.clear();
                  imageCropFiles.clear();

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

  void update({required final CategoryReadDto dto, required final int index}) {
    final TextEditingController controllerTitle = TextEditingController(text: dto.title);
    final TextEditingController controllerTitleTr1 = TextEditingController(text: dto.title);
    bottomSheet(
      child: column(
        mainAxisSize: MainAxisSize.min,
        height: 500,
        children: <Widget>[
          if ((dto.media ?? <MediaReadDto>[]).isNotEmpty) image((dto.media.imagesUrl() ?? <String>[]).firstOrNull ?? AppImages.logo),
          textField(text: "عنوان", controller: controllerTitle),
          textField(text: "عنوان انگلیسی", controller: controllerTitleTr1),
          button(
            width: 400,
            title: "ثبت",
            onTap: () {
              showEasyLoading();
              _categoryDataSource.update(
                dto: CategoryCreateUpdateDto(id: dto.id, title: controllerTitle.text, titleTr1: controllerTitleTr1.text),
                onResponse: (final GenericResponse<CategoryReadDto> response) {
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

  Widget _items({required final CroppedFile path, required final CroppedFile originalPath, required final int index, required final VoidCallback action}) => Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              // Image.network(originalPath.path, width: 128, height: 128, borderRadius: 16),
              Image.network(path.path, width: 128, height: 128),
              const Icon(
                Icons.close_outlined,
                size: 18,
                color: Colors.white,
              ).container(width: 22, height: 22, backgroundColor: Colors.red, radius: 50).marginAll(4).onTap(() {
                imageFiles.removeAt(index);
                action();
              }),
            ],
          ).marginSymmetric(horizontal: 4).onTap(() {
            push(ImagePreviewPage(imageFiles.map((final CroppedFile e) => e.path).toList(), currentIndex: index));
          }),
          const SizedBox(height: 8),
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
                imageCropFiles[index] = croppedFile!;
                action();
              },
            ),
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
