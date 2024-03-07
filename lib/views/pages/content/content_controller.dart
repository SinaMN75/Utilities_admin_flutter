import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin ContentController {
  final ContentDataSource _dataSource = ContentDataSource(baseUrl: AppConstants.baseUrl);
  final MediaDataSource _mediaDataSource = MediaDataSource(baseUrl: AppConstants.baseUrl);
  final Rx<PageState> state = PageState.initial.obs;
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
        title: "حذف",
        subtitle: "آیا از حذف محتوا اطمینان دارید",
        action1: (
          "بله",
          () {
            _dataSource.delete(
              id: dto.id!,
              onResponse: (final GenericResponse<dynamic> response) {},
              onError: (final GenericResponse<dynamic> response) {},
            );
            list.removeWhere((final ContentReadDto i) => i.id == dto.id);
            back();
          }
        ),
      );

  void createUpdate({final ContentReadDto? dto}) {
    final TextEditingController controllerTitle = TextEditingController(text: dto?.title);
    final TextEditingController controllerDescription = TextEditingController(text: dto?.description);
    final TextEditingController controllerInstagram = TextEditingController(text: dto?.jsonDetail.instagram);
    final TextEditingController controllerTelegram = TextEditingController(text: dto?.jsonDetail.telegram);
    final TextEditingController controllerWhatsapp = TextEditingController(text: dto?.jsonDetail.whatsApp);
    final TextEditingController controllerPhoneNumber = TextEditingController(text: dto?.jsonDetail.phoneNumber1);
    final TextEditingController controllerAddress = TextEditingController(text: dto?.jsonDetail.address1);
    final TextEditingController controllerWebSite = TextEditingController(text: dto?.jsonDetail.website);
    final Rx<TagContent> selectedTag = UtilitiesTagUtils.tagContentFromIntList(dto?.tags ?? <int>[]).obs;

    final List<FileData> deletedFiles = <FileData>[];
    final List<FileData> editedFiles = <FileData>[];
    List<FileData> files = <FileData>[];

    final GlobalKey<FormState> formKey = GlobalKey();
    dialogAlert(
      Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            Obx(
              () => DropdownButtonFormField<TagContent>(
                value: selectedTag.value,
                items: <DropdownMenuItem<TagContent>>[
                  DropdownMenuItem<TagContent>(value: TagContent.aboutUs, child: Text(TagContent.aboutUs.title)),
                  DropdownMenuItem<TagContent>(value: TagContent.terms, child: Text(TagContent.terms.title)),
                  DropdownMenuItem<TagContent>(value: TagContent.homeBanner1, child: Text(TagContent.homeBanner1.title)),
                  DropdownMenuItem<TagContent>(value: TagContent.homeBanner2, child: Text(TagContent.homeBanner2.title)),
                  DropdownMenuItem<TagContent>(value: TagContent.homeBannerSmall1, child: Text(TagContent.homeBannerSmall1.title)),
                  DropdownMenuItem<TagContent>(value: TagContent.homeBannerSmall2, child: Text(TagContent.homeBannerSmall2.title)),
                  DropdownMenuItem<TagContent>(value: TagContent.smallDetail1, child: Text(TagContent.smallDetail1.title)),
                  DropdownMenuItem<TagContent>(value: TagContent.smallDetail2, child: Text(TagContent.smallDetail2.title)),
                  DropdownMenuItem<TagContent>(value: TagContent.news, child: Text(TagContent.news.title)),
                  DropdownMenuItem<TagContent>(value: TagContent.premium, child: Text(TagContent.premium.title)),
                ],
                onChanged: selectedTag,
              ),
            ).paddingSymmetric(vertical: 4),
            textField(labelText: "عنوان", controller: controllerTitle).paddingSymmetric(vertical: 4),
            textField(
              labelText: "توضیحات",
              controller: controllerDescription,
              lines: 12,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            ).paddingSymmetric(vertical: 4),
            Row(
              children: <Widget>[
                textField(labelText: "اینستاگرام", controller: controllerInstagram).paddingAll(4).expanded(),
                textField(labelText: "تلگرام", controller: controllerTelegram).paddingAll(4).expanded(),
              ],
            ),
            Row(
              children: <Widget>[
                textField(labelText: "واتساپ", controller: controllerWhatsapp).paddingAll(4).expanded(),
                textField(labelText: "شماره تماس", controller: controllerPhoneNumber).paddingAll(4).expanded(),
              ],
            ),
            Row(
              children: <Widget>[
                textField(labelText: "آدرس", controller: controllerAddress).paddingAll(4).expanded(),
                textField(labelText: "وبسایت", controller: controllerWebSite).paddingAll(4).expanded(),
              ],
            ),
            const SizedBox(height: 8),
            filePickerList(
              title: "افزودن تصویر",
              files: files,
              onFileSelected: (final List<FileData> list) => files = list,
              onFileEdited: editedFiles.addAll,
              onFileDeleted: (final List<FileData> list) => list.forEach(
                (final FileData i) {
                  files.remove(i);
                  deletedFiles.add(i);
                },
              ),
            ),
            button(
              title: "ثبت",
              onTap: () => validateForm(
                key: formKey,
                action: () {
                  if (dto == null) {
                    showEasyLoading();
                    _dataSource.create(
                      dto: ContentCreateUpdateDto(
                        title: controllerTitle.text,
                        description: controllerDescription.text,
                        instagram: controllerInstagram.text,
                        website: controllerWebSite.text,
                        telegram: controllerTelegram.text,
                        whatsApp: controllerWhatsapp.text,
                        phoneNumber1: controllerPhoneNumber.text,
                        address1: controllerAddress.text,
                        tags: <int>[selectedTag.value.number],
                      ),
                      onResponse: (final GenericResponse<ContentReadDto> response) async {
                        await Future.forEach(files, (final FileData i) async {
                          if (i.parentId == null)
                            await _mediaDataSource.create(
                              parentId: i.parentId,
                              fileData: i,
                              id: i.id,
                              fileExtension: i.extension!,
                              contentId: response.result?.id,
                              tags: <int>[TagMedia.media.number],
                              onResponse: () {},
                              onError: () {},
                            );
                        });
                        await Future.forEach(files, (final FileData i) async {
                          if (i.parentId != null)
                            await _mediaDataSource.create(
                              parentId: i.parentId,
                              id: i.id,
                              fileData: i,
                              fileExtension: i.extension!,
                              contentId: response.result?.id,
                              tags: <int>[TagMedia.media.number],
                              onResponse: () {},
                              onError: () {},
                            );
                        });
                        list.add(response.result!);
                        await dismissEasyLoading();
                        back();
                      },
                      onError: (final GenericResponse<dynamic> response) {},
                    );
                  } else {
                    showEasyLoading();
                    _dataSource.update(
                      dto: ContentCreateUpdateDto(
                        id: dto.id,
                        title: controllerTitle.text,
                        description: controllerDescription.text,
                        instagram: controllerInstagram.text,
                        telegram: controllerTelegram.text,
                        website: controllerWebSite.text,
                        whatsApp: controllerWhatsapp.text,
                        phoneNumber1: controllerPhoneNumber.text,
                        address1: controllerAddress.text,
                        tags: <int>[selectedTag.value.number],
                      ),
                      onResponse: (final GenericResponse<ContentReadDto> response) {
                        files.forEach(
                          (final FileData i) async => _mediaDataSource.create(
                            fileData: i,
                            fileExtension: i.extension!,
                            contentId: response.result?.id,
                            tags: <int>[TagMedia.media.number],
                            onResponse: () {},
                            onError: () {},
                          ),
                        );
                        deletedFiles.forEach(
                          (final FileData i) => _mediaDataSource.delete(id: i.id!, onResponse: () {}, onError: () {}),
                        );
                        dismissEasyLoading();
                        back();
                      },
                      onError: (final GenericResponse<dynamic> response) {},
                    );
                  }
                },
              ),
            ).paddingSymmetric(vertical: 20),
          ],
        ).container(width: context.width / 1.2),
      ),
      contentPadding: const EdgeInsets.all(20),
      defaultCloseButton: true,
    );
  }
}
