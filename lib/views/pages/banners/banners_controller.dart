import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin BannersController {
  Rx<PageState> state = PageState.initial.obs;

  ContentReadDto? homeBanner1;
  ContentReadDto? homeBanner2;
  ContentReadDto? homeBannerSmall1;
  ContentReadDto? homeBannerSmall2;

  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();

  final ContentDataSource _contentDataSource = ContentDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    read();
  }

  void read() => _contentDataSource.read(
        onResponse: (final GenericResponse<ContentReadDto> response) {
          homeBanner1 = response.resultList!.firstWhereOrNull((final ContentReadDto i) => i.tags!.contains(TagContent.homeBanner1.number));
          homeBanner2 = response.resultList!.firstWhereOrNull((final ContentReadDto i) => i.tags!.contains(TagContent.homeBanner2.number));
          homeBannerSmall1 = response.resultList!.firstWhereOrNull((final ContentReadDto i) => i.tags!.contains(TagContent.homeBannerSmall1.number));
          homeBannerSmall2 = response.resultList!.firstWhereOrNull((final ContentReadDto i) => i.tags!.contains(TagContent.homeBannerSmall2.number));
          state.loaded();
        },
        onError: (final GenericResponse<dynamic> response) {},
      );

  void createUpdateHomeBanner1() {
    state.loading();
    if (homeBanner1 == null)
      _contentDataSource.create(
        dto: ContentCreateUpdateDto(title: controllerTitle.text, description: controllerDescription.text, tags: <int>[TagContent.homeBanner1.number]),
        onResponse: (final GenericResponse<ContentReadDto> response) => state.loaded(),
        onError: (final GenericResponse<dynamic> response) {},
      );
    else
      _contentDataSource.update(
        dto: ContentCreateUpdateDto(id: homeBanner1!.id, title: controllerTitle.text, description: controllerDescription.text),
        onResponse: (final GenericResponse<ContentReadDto> response) => state.loaded(),
        onError: (final GenericResponse<dynamic> response) {},
      );
  }

  void createUpdateHomeBanner2() {
    state.loading();
    if (homeBanner1 == null)
      _contentDataSource.create(
        dto: ContentCreateUpdateDto(title: controllerTitle.text, description: controllerDescription.text, tags: <int>[TagContent.homeBanner2.number]),
        onResponse: (final GenericResponse<ContentReadDto> response) => state.loaded(),
        onError: (final GenericResponse<dynamic> response) {},
      );
    else
      _contentDataSource.update(
        dto: ContentCreateUpdateDto(id: homeBanner2!.id, title: controllerTitle.text, description: controllerDescription.text),
        onResponse: (final GenericResponse<ContentReadDto> response) => state.loaded(),
        onError: (final GenericResponse<dynamic> response) {},
      );
  }

  void createUpdateHomeBannerSmall1() {
    state.loading();
    if (homeBanner1 == null)
      _contentDataSource.create(
        dto: ContentCreateUpdateDto(title: controllerTitle.text, description: controllerDescription.text, tags: <int>[TagContent.homeBannerSmall1.number]),
        onResponse: (final GenericResponse<ContentReadDto> response) => state.loaded(),
        onError: (final GenericResponse<dynamic> response) {},
      );
    else
      _contentDataSource.update(
        dto: ContentCreateUpdateDto(id: homeBannerSmall1!.id, title: controllerTitle.text, description: controllerDescription.text),
        onResponse: (final GenericResponse<ContentReadDto> response) => state.loaded(),
        onError: (final GenericResponse<dynamic> response) {},
      );
  }

  void createUpdateHomeBannerSmall2() {
    state.loading();
    if (homeBanner1 == null)
      _contentDataSource.create(
        dto: ContentCreateUpdateDto(title: controllerTitle.text, description: controllerDescription.text, tags: <int>[TagContent.homeBannerSmall2.number]),
        onResponse: (final GenericResponse<ContentReadDto> response) => state.loaded(),
        onError: (final GenericResponse<dynamic> response) {},
      );
    else
      _contentDataSource.update(
        dto: ContentCreateUpdateDto(id: homeBannerSmall2!.id, title: controllerTitle.text, description: controllerDescription.text),
        onResponse: (final GenericResponse<ContentReadDto> response) => state.loaded(),
        onError: (final GenericResponse<dynamic> response) {},
      );
  }
}
