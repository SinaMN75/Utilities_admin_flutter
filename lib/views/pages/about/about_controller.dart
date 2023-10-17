import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin AboutController {
  Rx<PageState> state = PageState.initial.obs;

  ContentReadDto? contentReadDto;

  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();

  final ContentDataSource _contentDataSource = ContentDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    read();
  }

  void read() => _contentDataSource.read(
        onResponse: (final GenericResponse<ContentReadDto> response) {
          contentReadDto = response.resultList!.firstWhereOrNull((final ContentReadDto i) => i.tags!.contains(TagContent.aboutUs.number));
          if (contentReadDto != null) {
            controllerTitle.text = contentReadDto?.title ?? "";
            controllerDescription.text = contentReadDto?.description ?? "";
          }
          state.loaded();
        },
        onError: (final GenericResponse<dynamic> response) {},
      );

  void createUpdate() {
    state.loading();
    if (contentReadDto == null)
      _contentDataSource.create(
        dto: ContentCreateUpdateDto(title: controllerTitle.text, description: controllerDescription.text, tags: <int>[TagContent.aboutUs.number]),
        onResponse: (final GenericResponse<ContentReadDto> response) {
          init();
        },
        onError: (final GenericResponse<dynamic> response) {},
      );
     else
      _contentDataSource.update(
        dto: ContentCreateUpdateDto(id: contentReadDto!.id, title: controllerTitle.text, description: controllerDescription.text),
        onResponse: (final GenericResponse<ContentReadDto> response) {
          init();
        },
        onError: (final GenericResponse<dynamic> response) {},
      );
  }
}
