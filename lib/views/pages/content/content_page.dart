import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/content/content_controller.dart';
import 'package:utilities_admin_flutter/views/widget/table.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  Key? get key => const Key("بنرها");

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> with ContentController, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return scaffold(
      constraints: const BoxConstraints(),
      appBar: AppBar(
        actions: <Widget>[
          if (Core.user.tags!.contains(TagUser.adminContentUpdate.number))
            IconButton(
              onPressed: _createUpdate,
              icon: const Icon(Icons.add_box_outlined, size: 40),
            ),
        ],
      ),
      body: Obx(
        () => state.isLoaded()
            ? Column(
                children: <Widget>[
                  DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text("ردیف")),
                      DataColumn(label: Text("تصویر")),
                      DataColumn(label: Text("عنوان")),
                      DataColumn(label: Text("توضیحات")),
                      DataColumn(label: Text("عملیات‌ها")),
                    ],
                    rows: <DataRow>[
                      ...list
                          .mapIndexed(
                            (final int index, final ContentReadDto i) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(index.toString())),
                                DataCell(dataTableImage(i.media.getImage())),
                                DataCell(Text(i.title ?? "")),
                                DataCell(Text(UtilitiesTagUtils.tagContentFromIntList(i.tags!).title)),
                                DataCell(
                                  Row(
                                    children: <Widget>[
                                      if (Core.user.tags!.contains(TagUser.adminContentUpdate.number))
                                        IconButton(
                                          onPressed: () => _delete(dto: i),
                                          icon: Icon(Icons.delete, color: context.theme.colorScheme.error),
                                        ).paddingSymmetric(horizontal: 8),
                                      if (Core.user.tags!.contains(TagUser.adminContentUpdate.number))
                                        IconButton(
                                          onPressed: () => _createUpdate(dto: i),
                                          icon: Icon(Icons.edit, color: context.theme.colorScheme.primary),
                                        ).paddingSymmetric(horizontal: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ],
                  ).container(width: double.infinity),
                ],
              )
            : const CircularProgressIndicator().alignAtCenter(),
      ),
    );
  }

  void _delete({required final ContentReadDto dto}) => alertDialog(
        title: "خذف",
        subtitle: "آیا از حذف محتوا اطمینان دارید",
        action1: ("بله", () => delete(dto: dto)),
      );

  void _createUpdate({final ContentReadDto? dto}) {
    final TextEditingController controllerTitle = TextEditingController(text: dto?.title);
    final TextEditingController controllerDescription = TextEditingController(text: dto?.description);
    final TextEditingController controllerInstagram = TextEditingController(text: dto?.jsonDetail?.instagram);
    final TextEditingController controllerTelegram = TextEditingController(text: dto?.jsonDetail?.telegram);
    final TextEditingController controllerWhatsapp = TextEditingController(text: dto?.jsonDetail?.whatsApp);
    final TextEditingController controllerPhoneNumber = TextEditingController(text: dto?.jsonDetail?.phoneNumber1);
    final TextEditingController controllerAddress = TextEditingController(text: dto?.jsonDetail?.address1);
    final Rx<TagContent> selectedTag = UtilitiesTagUtils.tagContentFromIntList(dto?.tags ?? <int>[]).obs;
    final GlobalKey<FormState> formKey = GlobalKey();
    dialogAlert(
      Form(
        key: formKey,
        child: Column(
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
            textField(labelText: "اینستاگرام", controller: controllerInstagram).paddingSymmetric(vertical: 4),
            textField(labelText: "تلگرام", controller: controllerTelegram).paddingSymmetric(vertical: 4),
            textField(labelText: "واتساپ", controller: controllerWhatsapp).paddingSymmetric(vertical: 4),
            textField(labelText: "شماره تماس", controller: controllerPhoneNumber).paddingSymmetric(vertical: 4),
            textField(labelText: "آدرس", controller: controllerAddress).paddingSymmetric(vertical: 4),
            button(
              title: "ثبت",
              onTap: () {
                validateForm(
                  key: formKey,
                  action: () => dto == null
                      ? create(
                          dto: ContentCreateUpdateDto(
                            title: controllerTitle.text,
                            description: controllerDescription.text,
                            instagram: controllerInstagram.text,
                            telegram: controllerTelegram.text,
                            whatsApp: controllerWhatsapp.text,
                            phoneNumber1: controllerPhoneNumber.text,
                            address1: controllerAddress.text,
                            tags: <int>[selectedTag.value.number],
                          ),
                        )
                      : update(
                          dto: ContentCreateUpdateDto(
                            id: dto.id,
                            title: controllerTitle.text,
                            description: controllerDescription.text,
                            instagram: controllerInstagram.text,
                            telegram: controllerTelegram.text,
                            whatsApp: controllerWhatsapp.text,
                            phoneNumber1: controllerPhoneNumber.text,
                            address1: controllerAddress.text,
                            tags: <int>[selectedTag.value.number],
                          ),
                        ),
                );
              },
            ).paddingSymmetric(vertical: 20),
          ],
        ).container(width: context.width / 1.2).scrollable(),
      ),
      contentPadding: const EdgeInsets.all(20),
      defaultCloseButton: true,
    );
  }
}
