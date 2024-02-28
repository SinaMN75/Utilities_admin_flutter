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
          () => _dataSource.delete(
                id: dto.id!,
                onResponse: (final GenericResponse<dynamic> response) {
                  list.removeWhere((final ContentReadDto i) => i.id == dto.id);
                  back();
                },
                onError: (final GenericResponse<dynamic> response) {},
              )
        ),
      );

  void createUpdate({final ContentReadDto? dto}) {
    final TextEditingController controllerTitle = TextEditingController(text: dto?.title);
    final TextEditingController controllerDescription = TextEditingController(text: dto?.description);
    final TextEditingController controllerInstagram = TextEditingController(text: dto?.jsonDetail?.instagram);
    final TextEditingController controllerTelegram = TextEditingController(text: dto?.jsonDetail?.telegram);
    final TextEditingController controllerWhatsapp = TextEditingController(text: dto?.jsonDetail?.whatsApp);
    final TextEditingController controllerPhoneNumber = TextEditingController(text: dto?.jsonDetail?.phoneNumber1);
    final TextEditingController controllerAddress = TextEditingController(text: dto?.jsonDetail?.address1);
    final TextEditingController controllerWebSite = TextEditingController(text: dto?.jsonDetail?.website);
    final Rx<TagContent> selectedTag = UtilitiesTagUtils.tagContentFromIntList(dto?.tags ?? <int>[]).obs;
    final List<FileData> deletedImages = <FileData>[];
    final List<FileData> editedImages = <FileData>[];
    final List<FileData> deletedPdfs = <FileData>[];
    final List<FileData> editedPdfs = <FileData>[];
    List<FileData> pdfs = (dto?.media ?? <MediaReadDto>[])
        .where((final MediaReadDto i) => i.tags!.contains(TagMedia.pdf.number))
        .map(
          (final MediaReadDto e) => FileData(url: e.url, id: e.id),
        )
        .toList();
    List<FileData> images = (dto?.media ?? <MediaReadDto>[])
        .where((final MediaReadDto i) => i.tags!.contains(TagMedia.image.number))
        .map(
          (final MediaReadDto e) => FileData(url: e.url, id: e.id),
        )
        .toList();
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
            filePickerList(
              title: "افزودن تصویر",
              files: images,
              onFileSelected: (final List<FileData> list) {
                images = list;
              },
              onFileDeleted: (final List<FileData> list) => list.forEach(
                (final FileData i) => pdfs.remove(i),
              ),
              onFileEdited: editedImages.addAll,
            ),
            const SizedBox(height: 12),
            filePickerList(
              title: "افزودن PDF",
              files: pdfs,
              onFileSelected: (final List<FileData> list) => pdfs = list,
              onFileDeleted: (final List<FileData> list) => list.forEach(
                (final FileData i) => pdfs.remove(i),
              ),
              onFileEdited: editedPdfs.addAll,
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
                      onResponse: (final GenericResponse<ContentReadDto> response) {
                        deletedImages.forEach((final FileData i) {
                          _mediaDataSource.delete(id: i.id!, onResponse: () {}, onError: () {});
                        });
                        deletedPdfs.forEach((final FileData i) {
                          _mediaDataSource.delete(id: i.id!, onResponse: () {}, onError: () {});
                        });
                        images.forEach((final FileData i) async {
                          _mediaDataSource.create(
                            fileData: i,
                            fileExtension: "jpg",
                            contentId: response.result?.id,
                            tags: <int>[TagMedia.image.number],
                            onResponse: () {},
                            onError: () {},
                          );
                        });
                        pdfs.forEach((final FileData i) async {
                          _mediaDataSource.create(
                            fileData: i,
                            fileExtension: "jpg",
                            contentId: response.result?.id,
                            tags: <int>[TagMedia.image.number],
                            onResponse: () {},
                            onError: () {},
                          );
                        });
                        list.add(response.result!);
                        snackbarDone();
                        dismissEasyLoading();
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
                        images.forEach(
                          (final FileData i) async => _mediaDataSource.create(
                            fileData: i,
                            fileExtension: "jpg",
                            contentId: response.result?.id,
                            tags: <int>[TagMedia.image.number],
                            onResponse: () {},
                            onError: () {},
                          ),
                        );
                        deletedImages.forEach(
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
