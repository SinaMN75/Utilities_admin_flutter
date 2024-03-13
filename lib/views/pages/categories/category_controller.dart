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

  void delete({required final CategoryReadDto dto}) {
    showEasyLoading();
    _categoryDataSource.delete(
      id: dto.id,
      onResponse: () {
        dismissEasyLoading();
        list.removeWhere((final CategoryReadDto i) => i.id == dto.id);
        filteredList.removeWhere((final CategoryReadDto i) => i.id == dto.id);
        back();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void create({final CategoryReadDto? dto}) {
    final TextEditingController controllerTitle = TextEditingController();
    final TextEditingController controllerTitleTr1 = TextEditingController();
    FileData? fileData;
    dialogAlert(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (dto != null) Text("زیردسته برای ${dto.title ?? ""}").paddingSymmetric(vertical: 12),
          textField(text: "عنوان", controller: controllerTitle).paddingSymmetric(vertical: 12),
          textField(text: "عنوان انگلیسی", controller: controllerTitleTr1).paddingSymmetric(vertical: 12),
          customImageCropper(
            maxImages: 1,
            result: (final List<FileData> cropFiles) {
              fileData = cropFiles.first;
            },
          ),
          button(
            title: "ثبت",
            onTap: () {
              _categoryDataSource.create(
                dto: CategoryCreateUpdateDto(
                  title: controllerTitle.text,
                  titleTr1: controllerTitleTr1.text,
                  parentId: dto?.id,
                  tags: <int>[TagCategory.category.number],
                ),
                onResponse: (final GenericResponse<CategoryReadDto> response) {
                  if (fileData != null) {
                    Core.fileUploadingCount(Core.fileUploadingCount.value += 1);
                    _mediaDataSource.create(
                      fileData: fileData!,
                      categoryId: response.result!.id,
                      fileExtension: "png",
                      tags: <int>[TagMedia.image.number],
                      onResponse: () => Core.fileUploadingCount(Core.fileUploadingCount.value - 1),
                      onError: () {},
                    );
                  }
                  list.add(response.result!);
                  filteredList.add(response.result!);
                  dismissEasyLoading();
                  controllerTitle.clear();
                  controllerTitleTr1.clear();
                  back();
                },
                onError: (final GenericResponse<dynamic> response) {},
              );
            },
          ).paddingSymmetric(vertical: 12),
        ],
      ).container(width: 500),
      contentPadding: const EdgeInsets.all(20),
    );
  }

  void update({required final CategoryReadDto dto}) {
    final TextEditingController controllerTitle = TextEditingController(text: dto.title);
    final TextEditingController controllerTitleTr1 = TextEditingController(text: dto.titleTr1);
    FileData? fileData;
    final RxBool hasImage = (dto.media.getImage() != null).obs;
    dialogAlert(
      Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            textField(text: "عنوان", controller: controllerTitle).paddingSymmetric(vertical: 12),
            textField(text: "عنوان انگلیسی", controller: controllerTitleTr1).paddingSymmetric(vertical: 12),
            if (hasImage.value)
              Stack(
                children: <Widget>[
                  image(dto.media!.getImage(), width: 100, height: 100),
                  IconButton(
                      onPressed: () {
                        hasImage(false);
                        _mediaDataSource.delete(id: dto.media!.first.id!, onResponse: () {}, onError: () {});
                      },
                      icon: Icon(Icons.delete, color: context.theme.colorScheme.error))
                ],
              ),
            customImageCropper(
              useCropper: false,
              maxImages: 1,
              result: (final List<FileData> cropFiles) {
                fileData = cropFiles.first;
              },
            ),
            button(
              title: "ثبت",
              onTap: () {
                showEasyLoading();
                _categoryDataSource.update(
                  dto: CategoryCreateUpdateDto(
                    id: dto.id,
                    title: controllerTitle.text,
                    titleTr1: controllerTitleTr1.text,
                    tags: <int>[TagCategory.category.number],
                  ),
                  onResponse: (final GenericResponse<CategoryReadDto> response) {
                    if (fileData != null)
                      _mediaDataSource.create(
                        fileData: fileData!,
                        categoryId: response.result!.id,
                        fileExtension: "png",
                        tags: <int>[TagMedia.image.number],
                        onResponse: () {},
                        onError: () {},
                      );
                    dismissEasyLoading();
                    controllerTitle.clear();
                    controllerTitleTr1.clear();
                    back();
                  },
                  onError: (final GenericResponse<dynamic> response) {},
                );
              },
            ).paddingSymmetric(vertical: 12),
          ],
        ),
      ).container(width: 500),
      contentPadding: const EdgeInsets.all(20),
    );
  }
}
