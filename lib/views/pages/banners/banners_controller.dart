import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin BannersController {
  Rx<PageState> state = PageState.initial.obs;

  ContentReadDto? homeBanner1;
  ContentReadDto? homeBanner2;
  ContentReadDto? homeBannerSmall1;
  ContentReadDto? homeBannerSmall2;

  final ContentDataSource _contentDataSource = ContentDataSource(baseUrl: AppConstants.baseUrl);
  final MediaDataSource _mediaDataSource = MediaDataSource(baseUrl: AppConstants.baseUrl);

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

  void createUpdateHomeBanner1() async {
    if (homeBanner1 == null) {
      state.loading();
      final XFile? file = await imagePicker();
      if (file != null)
      await _contentDataSource.create(
        dto: ContentCreateUpdateDto(tags: <int>[TagContent.homeBanner1.number]),
        onResponse: (final GenericResponse<ContentReadDto> response) async {
          uploadImage(byte: await file.readAsBytes(), form: MapEntry<String, String>("ContentId", response.result!.id!));
          state.loaded();
        },
        onError: (final GenericResponse<dynamic> response) {},
      );
    } else {
      final XFile? file = await imagePicker();
      if (file != null) {
        state.loading();
        await _mediaDataSource.delete(
          id: homeBanner1?.media?.firstOrNull?.id ?? "",
          onResponse: (final GenericResponse<dynamic> response) async {
            state.loaded();
          },
          onError: (final GenericResponse<dynamic> response) {},
        );
      }
    }
  }

  void createUpdateHomeBanner2() async {
    if (homeBanner2 == null) {
      state.loading();
      final XFile? file = await imagePicker();
      if (file != null)
      await _contentDataSource.create(
        dto: ContentCreateUpdateDto(tags: <int>[TagContent.homeBanner2.number]),
        onResponse: (final GenericResponse<ContentReadDto> response) async {
          uploadImage(byte: await file.readAsBytes(), form: MapEntry<String, String>("ContentId", response.result!.id!));
          state.loaded();
        },
        onError: (final GenericResponse<dynamic> response) {},
      );
    } else {
      final XFile? file = await imagePicker();
      if (file != null) {
        state.loading();
        await _mediaDataSource.delete(
          id: homeBanner2?.media?.firstOrNull?.id ?? "",
          onResponse: (final GenericResponse<dynamic> response) async {
            state.loaded();
          },
          onError: (final GenericResponse<dynamic> response) {},
        );
      }
    }
  }

  void createUpdateHomeBannerSmall1() async {
    if (homeBannerSmall1 == null) {
      state.loading();
      final XFile? file = await imagePicker();
      if (file != null)
      await _contentDataSource.create(
        dto: ContentCreateUpdateDto(tags: <int>[TagContent.homeBannerSmall1.number]),
        onResponse: (final GenericResponse<ContentReadDto> response) async {
          uploadImage(byte: await file.readAsBytes(), form: MapEntry<String, String>("ContentId", response.result!.id!));
          state.loaded();
        },
        onError: (final GenericResponse<dynamic> response) {},
      );
    } else {
      final XFile? file = await imagePicker();
      if (file != null) {
        state.loading();
        await _mediaDataSource.delete(
          id: homeBannerSmall1?.media?.firstOrNull?.id ?? "",
          onResponse: (final GenericResponse<dynamic> response) async {
            state.loaded();
          },
          onError: (final GenericResponse<dynamic> response) {},
        );
      }
    }
  }

  void createUpdateHomeBannerSmall2() async {
    if (homeBannerSmall2 == null) {
      state.loading();
      final XFile? file = await imagePicker();
      if (file != null)
      await _contentDataSource.create(
        dto: ContentCreateUpdateDto(tags: <int>[TagContent.homeBannerSmall2.number]),
        onResponse: (final GenericResponse<ContentReadDto> response) async {
          uploadImage(byte: await file.readAsBytes(), form: MapEntry<String, String>("ContentId", response.result!.id!));
          state.loaded();
        },
        onError: (final GenericResponse<dynamic> response) {},
      );
    } else {
      final XFile? file = await imagePicker();
      if (file != null) {
        state.loading();
        await _mediaDataSource.delete(
          id: homeBannerSmall2?.media?.firstOrNull?.id ?? "",
          onResponse: (final GenericResponse<dynamic> response) async {
            state.loaded();
          },
          onError: (final GenericResponse<dynamic> response) {},
        );
      }
    }
  }
}
