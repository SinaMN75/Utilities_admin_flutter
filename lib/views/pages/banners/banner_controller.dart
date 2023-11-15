import 'dart:io';

import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin BannerController {
  final ContentDataSource _dataSource = ContentDataSource(baseUrl: AppConstants.baseUrl);
  final MediaDataSource _mediaDataSource = MediaDataSource(baseUrl: AppConstants.baseUrl);
  Rx<PageState> state = PageState.initial.obs;

  final RxList<ContentReadDto> list = <ContentReadDto>[].obs;

  void init() {
    read();
  }

  void read() {
    state.loading();
    _dataSource.read(
      onResponse: (final GenericResponse<ContentReadDto> response) {
        list(response.resultList);
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void delete({required final ContentReadDto dto}) => alertDialog(
        title: "خذف",
        subtitle: "آیا از حذف دسته بندی اطمینان دارید",
        action1: (
          "بله",
          () {
            showEasyLoading();
            _dataSource.delete(
              id: dto.id!,
              onResponse: (final GenericResponse<dynamic> response) {
                snackbarGreen(title: "", subtitle: "حذف دسته بندی ${dto.title} انجام شد");
                list.removeWhere((final ContentReadDto i) => i.id == dto.id);
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

  void create({required final VoidCallback action, final ContentReadDto? dto}) {
    final TextEditingController controllerTitle = TextEditingController();
    final TextEditingController controllerDescription = TextEditingController();
    bottomSheet(
      child: column(
        mainAxisSize: MainAxisSize.min,
        height: 500,
        children: <Widget>[
          if (dto != null) Text("زیردسته برای ${dto.title ?? ""}"),
          textField(text: "عنوان", controller: controllerTitle),
          textField(text: "عنوان انگلیسی", controller: controllerDescription),
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
              _dataSource.create(
                dto: ContentCreateUpdateDto(
                  title: controllerTitle.text,
                  description: controllerDescription.text,
                ),
                onResponse: (final GenericResponse<ContentReadDto> response) {
                  if (isWeb) {
                    GetConnect().post(
                      "https://api.sinamn75.com/api/Media",
                      FormData(<String, dynamic>{
                        'Files': MultipartFile(File(cropFiles.value.path).readAsBytes(), filename: ':).png'),
                        "ContentIdId": response.result!.id,
                      }),
                      headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
                      contentType: "multipart/form-data",
                    );
                  } else {
                    GetConnect().post(
                      "https://api.sinamn75.com/api/Media",
                      FormData(<String, dynamic>{
                        'Files': MultipartFile(File(cropFiles.value.path), filename: ':).png'),
                        "ContentIdId": response.result!.id,
                      }),
                      headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
                      contentType: "multipart/form-data",
                    );
                  }

                  cropFiles(CroppedFile(''));
                  baseCropFiles(CroppedFile(''));

                  list.add(response.result!);
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

  void update({required final ContentReadDto dto, required final int index, required final VoidCallback action}) {
    final TextEditingController controllerTitle = TextEditingController(text: dto.title);
    final TextEditingController controllerDescription = TextEditingController(text: dto.description);
    final List<String> listOfDeleteImage = <String>[];
    bottomSheet(
      child: column(
        mainAxisSize: MainAxisSize.min,
        height: 500,
        children: <Widget>[
          if ((dto.media ?? <MediaReadDto>[]).isNotEmpty) image((dto.media.imagesUrl() ?? <String>[]).firstOrNull ?? AppImages.logo),
          textField(text: "عنوان", controller: controllerTitle),
          textField(text: "توضیحات", controller: controllerDescription),
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
              _dataSource.update(
                dto: ContentCreateUpdateDto(id: dto.id, title: controllerTitle.text, description: controllerDescription.text),
                onResponse: (final GenericResponse<ContentReadDto> response) {
                  listOfDeleteImage.forEach((final String element) {
                    _mediaDataSource.delete(
                      id: element,
                      onResponse: () {},
                      onError: () {},
                    );
                  });

                  if (isWeb) {
                    GetConnect().post(
                      "https://api.sinamn75.com/api/Media",
                      FormData(<String, dynamic>{
                        'Files': MultipartFile(cropFiles.value.readAsBytes(), filename: ':).png'),
                        "ContentId": response.result!.id,
                      }),
                      headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
                      contentType: "multipart/form-data",
                    );
                  } else {
                    GetConnect().post(
                      "https://api.sinamn75.com/api/Media",
                      FormData(<String, dynamic>{
                        'Files': MultipartFile(File(cropFiles.value.path), filename: ':).png'),
                        "ContentId": response.result!.id,
                      }),
                      headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
                      contentType: "multipart/form-data",
                    );
                  }

                  cropFiles(CroppedFile(''));
                  baseCropFiles(CroppedFile(''));

                  list.removeAt(index);
                  list.insert(index, response.result!);
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
          ).marginSymmetric(horizontal: 4),
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
}
