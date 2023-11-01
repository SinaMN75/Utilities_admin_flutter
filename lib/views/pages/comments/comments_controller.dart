import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin CommentsController {
  Rx<PageState> state = PageState.initial.obs;

  final RxList<CommentReadDto> list = <CommentReadDto>[].obs;

  final TextEditingController controllerTitle = TextEditingController();
  final RxInt selectedCommentTag = TagComment.all.number.obs;

  int pageNumber = 1;
  int pageCount = 0;

  final CommentDataSource _commentDataSource = CommentDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    read();
  }

  void read() {
    state.loading();
    _commentDataSource.filter(
      dto: CommentFilterDto(
        pageSize: 20,
        pageNumber: pageNumber,
        tags: selectedCommentTag.value != TagComment.all.number ? <int>[selectedCommentTag.value] : <int>[],
      ),
      onResponse: (final GenericResponse<CommentReadDto> response) {
        // pageCount = response.pageCount!;
        list(response.resultList);
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void delete({required final CommentReadDto dto}) => alertDialog(
        title: "خذف",
        subtitle: "آیا از حذف محصول اطمینان دارید",
        action1: (
          "بله",
          () {
            showEasyLoading();
            _commentDataSource.delete(
              id: dto.id!,
              onResponse: (final GenericResponse<dynamic> response) {
                snackbarGreen(title: "", subtitle: "انجام شد");
                list.removeWhere((final CommentReadDto i) => i.id == dto.id);
              },
              onError: (final GenericResponse<dynamic> response) {},
            );
          }
        ),
      );

  void update({required final CommentCreateUpdateDto dto}) {
    _commentDataSource.update(
      id: dto.id!,
      dto: CommentCreateUpdateDto(tags: dto.tags),
      onResponse: (final GenericResponse<CommentReadDto> response) {
        dismissEasyLoading();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }
}
