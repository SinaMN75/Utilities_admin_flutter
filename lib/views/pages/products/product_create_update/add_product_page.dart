import 'dart:io';

import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/products/product_create_update/add_product_controller.dart';
import 'package:utilities_admin_flutter/views/widget/image_preview_page.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key, this.dto, this.action, this.isFromInstagram, this.images, this.description});

  final ProductReadDto? dto;
  final List<String>? images;
  final String? description;
  final bool? isFromInstagram;
  final VoidCallback? action;

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> with AddProductController {
  @override
  void initState() {
    dto = widget.dto;
    isFromInstagram = widget.isFromInstagram ?? false;
    getProductById(id: dto?.id);
    images = dto?.media.getImages() ?? widget.images;
    imageCropFiles = imageFiles;
    if ((images ?? <String>[]).isNotEmpty) {
      addToImageFile(images ?? <String>[], () {
        description = widget.description ?? '';
        imageCropFiles = imageFiles;
        init();
        setState(() {});
      });
    } else {
      init();
    }

    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      body: Obx(
        () => state.isLoaded()
            ? SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text("انتخاب دسته‌بندی").bodyMedium(),
                      Obx(() => DropdownButtonFormField<CategoryReadDto>(
                            value: selectedCategory.value,
                            items: <DropdownMenuItem<CategoryReadDto>>[
                              ...categories
                                  .map(
                                    (final CategoryReadDto e) => DropdownMenuItem<CategoryReadDto>(
                                      value: e,
                                      child: Text(e.title ?? ""),
                                    ),
                                  )
                                  .toList(),
                            ],
                            onChanged: selectCategory,
                          )).paddingSymmetric(vertical: 8),
                      const Text("انتخاب زیر دسته").bodyMedium(),
                      Obx(() => DropdownButtonFormField<CategoryReadDto>(
                            value: selectedSubCategory.value,
                            items: <DropdownMenuItem<CategoryReadDto>>[
                              ...subCategories
                                  .map(
                                    (final CategoryReadDto e) => DropdownMenuItem<CategoryReadDto>(
                                      value: e,
                                      child: Text(e.title ?? ""),
                                    ),
                                  )
                                  .toList(),
                            ],
                            onChanged: selectSubCategory,
                          )).paddingSymmetric(vertical: 8),
                      textField(text: "عنوان", controller: controllerTitle, validator: validateNotEmpty()).marginSymmetric(vertical: 8),
                      const SizedBox(height: 8),
                      const Text("افزودن تصویر"),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            ...imageCropFiles
                                .mapIndexed((final int index, final File item) => _items(path: item, originalPath: imageFiles[index], index: index).marginSymmetric(horizontal: 4))
                                .toList(),
                            Container(
                              child: Icon(Icons.add, size: 60, color: context.theme.dividerColor)
                                  .container(
                                    radius: 10,
                                    borderColor: context.theme.dividerColor,
                                    width: 100,
                                    height: 100,
                                  )
                                  .onTap(
                                    () => cropImageCrop(
                                      result: (final CroppedFile cropped) {
                                        imageFiles.add(File(cropped.path));
                                        // imageCropFiles.add(File(cropped.path));
                                        setState(() {});
                                        debugPrint("DDDD");
                                        // cropperCropFiles.add(cropped);
                                        // result(cropperFiles);
                                      },
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      _keyValue().paddingSymmetric(vertical: 12),
                      _subProducts().paddingSymmetric(vertical: 12),
                      const SizedBox(height: 20),
                      textField(
                        text: "توضیحات تکمیلی",
                        controller: controllerDescription,
                        keyboardType: TextInputType.multiline,
                        lines: 3,
                        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      ).paddingSymmetric(vertical: 8),
                      if (Core.user.tags!.contains(TagUser.adminProductUpdate.number))
                        button(
                        title: "ثبت",
                        onTap: () => createUpdate(action: () => widget.action?.call()),
                      ).paddingOnly(bottom: 40),
                    ],
                  ).paddingOnly(top: 8, right: 16, left: 16, bottom: 50),
                ),
              )
            : const CircularProgressIndicator().alignAtCenter(),
      )).safeArea();

  Widget _items({required final File path, required final File originalPath, required final int index}) => Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              imageFile(path, width: 128, height: 128, borderRadius: 16),
              const Icon(
                Icons.close_outlined,
                size: 18,
                color: Colors.white,
              ).container(width: 22, height: 22, backgroundColor: Colors.red, radius: 50).marginAll(4).onTap(() {
                imageFiles.removeAt(index);
                setState(() {});
              }),
            ],
          ).marginSymmetric(horizontal: 4).onTap(() {
            push(ImagePreviewPage(images!, currentIndex: index));
          }),
          const SizedBox(height: 8),
          SizedBox(
            child: button(
              title: 'کراپ',
              width: 100,
              onTap: () async {
                final CroppedFile? croppedFile = await ImageCropper().cropImage(
                  sourcePath: originalPath.path,
                  aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                  uiSettings: <PlatformUiSettings>[
                    WebUiSettings(context: context, enforceBoundary: true, enableExif: true, enableZoom: true, showZoomer: true),
                  ],
                );
                imageCropFiles[index] = File(croppedFile!.path);
                setState(() {});
              },
            ),
          ),
        ],
      );

  Widget _keyValue() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController controllerKey = TextEditingController();
    final TextEditingController controllerValue = TextEditingController();
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("ویژگی‌ها").bodyLarge().paddingOnly(bottom: 8),
          if (keyValueList.length <= 4)
            Form(
              key: _formKey,
              child: Row(
                children: <Widget>[
                  textField(controller: controllerKey, hintText: "مثال: جنس", validator: validateNotEmpty()).expanded(),
                  const SizedBox(width: 16),
                  textField(controller: controllerValue, hintText: "مثال: چرم", validator: validateNotEmpty()).expanded(),
                  const Icon(Icons.add).paddingSymmetric(horizontal: 8).onTap(() {
                    validateForm(
                      key: _formKey,
                      action: () {
                        keyValueList.add(KeyValueViewModel(controllerKey.text, controllerValue.text));
                        controllerKey.clear();
                        controllerValue.clear();
                      },
                    );
                  }),
                ],
              ),
            ).marginOnly(bottom: 4),
          ...keyValueList
              .map(
                (final KeyValueViewModel e) => Row(
                  children: <Widget>[
                    Text(e.key)
                        .bodyMedium()
                        .container(
                          backgroundColor: context.theme.hintColor.withOpacity(0.1),
                          radius: 12,
                          padding: const EdgeInsets.all(8),
                        )
                        .expanded(),
                    const SizedBox(width: 16),
                    Text(e.value)
                        .bodyMedium()
                        .container(
                          backgroundColor: context.theme.hintColor.withOpacity(0.1),
                          radius: 12,
                          padding: const EdgeInsets.all(8),
                        )
                        .expanded(),
                    Icon(Icons.remove, color: context.theme.colorScheme.error).paddingSymmetric(horizontal: 8).onTap(() {
                      keyValueList.remove(e);
                    }),
                  ],
                ).paddingSymmetric(vertical: 4),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _subProducts() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController des = TextEditingController();
    final TextEditingController price = TextEditingController();
    final TextEditingController stock = TextEditingController();
    final Rx<Color> color = Colors.transparent.obs;
    String colorString = "";
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("مشخصات، موجودی و قیمت محصول").bodyLarge().paddingOnly(bottom: 12),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Obx(
                      () => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(color: color.value, shape: BoxShape.circle, border: Border.all()),
                      ).onTap(
                        () => showColorPickerBottomSheet(
                          pickerColor: color.value,
                          onColorChanged: (final Color selectedColor) {
                            color(selectedColor);
                            colorString = colorToHexColor(selectedColor);
                          },
                        ),
                      ),
                    ),
                    textField(
                      hintText: "مشخصه",
                      controller: des,
                      maxLength: 50,
                      validator: validateNotEmpty(),
                    ).marginSymmetric(horizontal: 4).expanded(),
                  ],
                ).marginOnly(bottom: 8),
                Row(
                  children: <Widget>[
                    textField(
                      hintText: "قیمت (تومان)",
                      controller: price,
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      validator: validateNumber(),
                    ).marginSymmetric(horizontal: 4).expanded(),
                    textField(
                      hintText: "تعداد",
                      controller: stock,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      validator: validateNumber(),
                    ).marginSymmetric(horizontal: 4).expanded(),
                    Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ).onTap(() {
                        validateForm(
                          key: _formKey,
                          action: () {
                            subProducts.add(
                              ProductCreateUpdateDto(title: des.text, color: colorString, stock: stock.text.toInt(), price: price.text.toInt()),
                            );
                            des.clear();
                            colorString = "";
                            color(Colors.transparent);
                            stock.clear();
                            price.clear();
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ...subProducts
              .map(
                (final ProductCreateUpdateDto i) => Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(color: hexStringToColor(i.color!), shape: BoxShape.circle, border: Border.all()),
                        ),
                        Text(i.title!)
                            .bodyMedium()
                            .container(
                              backgroundColor: context.theme.hintColor.withOpacity(0.1),
                              radius: 12,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                            )
                            .expanded(),
                      ],
                    ).paddingSymmetric(vertical: 8),
                    Row(
                      children: <Widget>[
                        Text(i.price.toString().separateNumbers3By3())
                            .bodyMedium()
                            .container(
                              backgroundColor: context.theme.hintColor.withOpacity(0.1),
                              radius: 12,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                            )
                            .expanded(),
                        Text(i.stock.toString())
                            .bodyMedium()
                            .container(
                              backgroundColor: context.theme.hintColor.withOpacity(0.1),
                              radius: 12,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                            )
                            .expanded(),
                        Icon(Icons.remove, color: context.theme.colorScheme.error).onTap(() {
                          subProducts.remove(i);
                          deletedSubProducts.add(i);
                        }),
                      ],
                    ).paddingSymmetric(vertical: 8),
                    Divider(
                      endIndent: 16,
                      indent: 16,
                      color: context.theme.primaryColorDark.withOpacity(0.1),
                    ),
                  ],
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
