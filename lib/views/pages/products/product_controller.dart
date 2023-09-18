import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin ProductController {
  Rx<PageState> state = PageState.initial.obs;

  final RxList<ProductReadDto> list = <ProductReadDto>[].obs;
  final RxList<ProductReadDto> filteredList = <ProductReadDto>[].obs;

  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerTitleTr1 = TextEditingController();

  final ProductDataSource _productDataSource = ProductDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    if (list.isEmpty)
      read();
    else
      state.loaded();
  }

  void filter() {
  }

  void read() {
    state.loading();
    _productDataSource.filter(
      dto: ProductFilterDto(),
      onResponse: (final GenericResponse<ProductReadDto> response) {
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
    final TextEditingController controllerTitle = TextEditingController();
    bottomSheet(
      child: column(
        mainAxisSize: MainAxisSize.min,
        height: 500,
        children: <Widget>[
          if (dto != null) Text("زیردسته برای ${dto.title ?? ""}"),
          textField(text: "عنوان"),
          const SizedBox(height: 20),
          button(
            width: 400,
            title: "ثبت",
            onTap: () {
              showEasyLoading();
              _productDataSource.create(
                dto: ProductCreateUpdateDto(title: controllerTitle.text, parentId: dto?.id),
                onResponse: (final GenericResponse<ProductReadDto> response) {
                  dismissEasyLoading();
                  controllerTitle.clear();
                },
                onError: (final GenericResponse<dynamic> response) {},
              );
            },
          ),
        ],
      ),
    );
  }

  void update({required final ProductReadDto dto}) {
    final TextEditingController controllerTitle = TextEditingController(text: dto.title);
    bottomSheet(
      child: column(
        mainAxisSize: MainAxisSize.min,
        height: 500,
        children: <Widget>[
          textField(text: "عنوان", controller: controllerTitle),
          const SizedBox(height: 20),
          button(
            width: 400,
            title: "ثبت",
            onTap: () {
              showEasyLoading();
              _productDataSource.update(
                dto: ProductCreateUpdateDto(id: dto.id, title: controllerTitle.text),
                onResponse: (final GenericResponse<ProductReadDto> response) {
                  dismissEasyLoading();
                  controllerTitle.clear();
                },
                onError: (final GenericResponse<dynamic> response) {},
              );
            },
          ),
        ],
      ),
    );
  }
}
