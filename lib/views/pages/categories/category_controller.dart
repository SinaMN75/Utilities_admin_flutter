import 'package:flutter/foundation.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin CategoryController {
  Rx<PageState> state = PageState.initial.obs;

  final RxList<CategoryReadDto> list = <CategoryReadDto>[].obs;
  final RxList<CategoryReadDto> filteredList = <CategoryReadDto>[].obs;

  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerTitleTr1 = TextEditingController();

  final CategoryDataSource _categoryDataSource = CategoryDataSource(baseUrl: AppConstants.baseUrl);
  final MediaDataSource _mediaDataSource = MediaDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    if (list.isEmpty)
      read();
    else
      state.loaded();
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
      dto: CategoryFilterDto(showMedia: true),
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

  void create({final CategoryReadDto? dto}) {
    final TextEditingController controllerTitle = TextEditingController();
    Uint8List? fileByte;
    bottomSheet(
      child: column(
        mainAxisSize: MainAxisSize.min,
        height: 500,
        children: <Widget>[
          if (dto != null) Text("زیردسته برای ${dto.title ?? ""}"),
          textField(text: "عنوان", controller: controllerTitle),
          const SizedBox(height: 20),
          customWebImageCropper(
            maxImages: 1,
            result: (final List<CroppedFile> cropFiles) async {
              fileByte = await cropFiles.first.readAsBytes();
            },
          ),
          button(
            width: 400,
            title: "ثبت",
            onTap: () {
              showEasyLoading();
              _categoryDataSource.create(
                dto: CategoryCreateUpdateDto(title: controllerTitle.text, parentId: dto?.id),
                onResponse: (final GenericResponse<CategoryReadDto> response) {
                  dismissEasyLoading();
                  controllerTitle.clear();
                  if (fileByte != null) uploadImage(byte: fileByte!, form: MapEntry<String, String>("CategoryId", response.result!.id));
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

  void update({required final CategoryReadDto dto}) {
    final TextEditingController controllerTitle = TextEditingController(text: dto.title);
    Uint8List? fileByte;
    bottomSheet(
      child: column(
        mainAxisSize: MainAxisSize.min,
        height: 500,
        children: <Widget>[
          if ((dto.media ?? <MediaReadDto>[]).isNotEmpty) image((dto.media.imagesUrl() ?? <String>[]).firstOrNull ?? AppImages.logo),
          textField(text: "عنوان", controller: controllerTitle),
          const SizedBox(height: 20),
          customWebImageCropper(
            maxImages: 1,
            result: (final List<CroppedFile> cropFiles) async {
              fileByte = await cropFiles.first.readAsBytes();
            },
          ),
          button(
            width: 400,
            title: "ثبت",
            onTap: () {
              showEasyLoading();
              _categoryDataSource.update(
                dto: CategoryCreateUpdateDto(id: dto.id, title: controllerTitle.text),
                onResponse: (final GenericResponse<CategoryReadDto> response) {
                  dismissEasyLoading();
                  controllerTitle.clear();
                  if (fileByte != null) {
                    (dto.media ?? <MediaReadDto>[]).forEach((final MediaReadDto i) {
                      _mediaDataSource.delete(
                        id: i.id!,
                        onResponse: (final GenericResponse<dynamic> _) {
                          uploadImage(byte: fileByte!, form: MapEntry<String, String>("CategoryId", dto.id));
                        },
                        onError: (final GenericResponse<dynamic> response) {},
                      );
                    });
                  }
                },
                onError: (final GenericResponse<dynamic> response) {},
              );
            },
          ),
        ],
      ),
    );
  }

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
