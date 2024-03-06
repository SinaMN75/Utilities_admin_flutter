import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin SpecialitiesController {
  final CategoryDataSource _categoryDataSource = CategoryDataSource(baseUrl: AppConstants.baseUrl);
  Rx<PageState> state = PageState.initial.obs;

  final RxList<CategoryReadDto> list = <CategoryReadDto>[].obs;
  final RxList<CategoryReadDto> filteredList = <CategoryReadDto>[].obs;

  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerTitleTr1 = TextEditingController();

  void init() {
    read();
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
      dto: CategoryFilterDto(showMedia: true, tags: <int>[TagCategory.speciality.number]),
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

  void create() {
    final TextEditingController controllerTitle = TextEditingController();
    final TextEditingController controllerTitleTr1 = TextEditingController();
    dialogAlert(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          textField(text: "عنوان", controller: controllerTitle).paddingSymmetric(vertical: 12),
          textField(text: "عنوان انگلیسی", controller: controllerTitleTr1).paddingSymmetric(vertical: 12),
          button(
            title: "ثبت",
            onTap: () {
              showEasyLoading();
              _categoryDataSource.create(
                dto: CategoryCreateUpdateDto(
                  title: controllerTitle.text,
                  titleTr1: controllerTitleTr1.text,
                  tags: <int>[TagCategory.speciality.number],
                ),
                onResponse: (final GenericResponse<CategoryReadDto> response) {
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
    dialogAlert(
      Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            textField(text: "عنوان", controller: controllerTitle).paddingSymmetric(vertical: 12),
            textField(text: "عنوان انگلیسی", controller: controllerTitleTr1).paddingSymmetric(vertical: 12),
            button(
              title: "ثبت",
              onTap: () {
                showEasyLoading();
                _categoryDataSource.update(
                  dto: CategoryCreateUpdateDto(
                    id: dto.id,
                    title: controllerTitle.text,
                    titleTr1: controllerTitleTr1.text,
                    tags: <int>[TagCategory.speciality.number],
                  ),
                  onResponse: (final GenericResponse<CategoryReadDto> response) {
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
