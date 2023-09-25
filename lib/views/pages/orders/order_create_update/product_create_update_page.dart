import 'package:utilities/components/crop_image_crop.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/products/product_create_update/product_create_update_controller.dart';

class ProductCreateUpdatePage extends StatefulWidget {
  const ProductCreateUpdatePage({this.dto, super.key});

  final ProductReadDto? dto;

  @override
  State<ProductCreateUpdatePage> createState() => _ProductCreateUpdatePageState();
}

class _ProductCreateUpdatePageState extends State<ProductCreateUpdatePage> with ProductCreateUpdateController {
  @override
  void initState() {
    dto = widget.dto;
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
        appBar: AppBar(title: const Text("")),
        body: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                textField(text: "عنوان").paddingSymmetric(vertical: 8),
                textField(text: "توضیحات").paddingSymmetric(vertical: 8),
                const Text("دسته بندی").paddingSymmetric(vertical: 8),
                DropdownButtonFormField<CategoryReadDto>(
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
                ).paddingSymmetric(vertical: 8),
                const Text("زیر دسته").paddingSymmetric(vertical: 8),
                DropdownButtonFormField<CategoryReadDto>(
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
                  onChanged: (final CategoryReadDto? value) {},
                ).paddingSymmetric(vertical: 8),
                const Text("ویژگی‌ها").paddingSymmetric(vertical: 8),
                _keyValue(),
                const Text("انواع").paddingSymmetric(vertical: 8),
                _subProducts(),
                customImageCropper(
                  result: (final List<CroppedFile> result) async {
                    final Response<dynamic> response = await GetConnect().post(
                      "https://api.sinamn75.com/api/Media",
                      FormData(<String, dynamic>{'Files': MultipartFile(await result.first.readAsBytes(), filename: ':).png')}),
                      headers: <String, String>{"Authorization": getString(UtilitiesConstants.token) ?? ""},
                      contentType: "multipart/form-data",
                    );
                  },
                ),
                button(
                    title: "ثبت",
                    onTap: () {
                      keyValueList.forEach((final KeyValueViewModel element) {});
                    })
              ],
            ),
          ),
        ),
      );

  Widget _keyValue() {
    final TextEditingController controllerKey = TextEditingController();
    final TextEditingController controllerValue = TextEditingController();
    return Obx(
      () => Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              textField(controller: controllerKey).expanded(),
              textField(controller: controllerValue).paddingSymmetric(horizontal: 12).expanded(),
              const Icon(Icons.add).onTap(() {
                if (controllerValue.text.isNotEmpty && controllerKey.text.isNotEmpty) {
                  keyValueList.add(KeyValueViewModel(controllerKey.text, controllerValue.text));
                  controllerKey.clear();
                  controllerValue.clear();
                }
              }),
            ],
          ).paddingSymmetric(vertical: 8),
          ...keyValueList
              .map(
                (final KeyValueViewModel e) => Row(
                  children: <Widget>[
                    Text(e.key)
                        .headlineMedium()
                        .container(
                          backgroundColor: context.theme.hintColor.withOpacity(0.1),
                          radius: 12,
                          padding: const EdgeInsets.all(8),
                        )
                        .expanded(),
                    const SizedBox(width: 12),
                    Text(e.value)
                        .headlineMedium()
                        .container(
                          backgroundColor: context.theme.hintColor.withOpacity(0.1),
                          radius: 12,
                          padding: const EdgeInsets.all(8),
                        )
                        .expanded()
                  ],
                ).paddingSymmetric(vertical: 8),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _subProducts() => Obx(
        () => Column(
          children: subProducts.mapIndexed((final int index, final ProductCreateUpdateDto i) {
            final TextEditingController des = TextEditingController();
            final TextEditingController price = TextEditingController();
            final TextEditingController stock = TextEditingController();
            final Rx<Color> color = const Color(0xFFFFFFFF).obs;
            des.text = dto?.description ?? '';
            price.text = (dto?.price ?? 0).toString();
            stock.text = (dto?.stock ?? 0).toString();
            return Obx(
              () => Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(color: color.value, shape: BoxShape.circle, border: Border.all()),
                  ).onTap(() {
                    showColorPickerBottomSheet(
                        pickerColor: color.value,
                        onColorChanged: (final Color value) {
                          subProducts[index].color = colorToHex(value);
                          color(value);
                        });
                  }),
                  textField(
                    text: "توضیحات",
                    controller: des,
                    maxLength: 50,
                    onChanged: (final String value) => subProducts[index].description = value,
                  ).marginSymmetric(horizontal: 8).expanded(),
                  textField(
                    text: "قیمت",
                    controller: price,
                    maxLength: 12,
                    onChanged: (final String value) => subProducts[index].price = int.parse(value),
                  ).marginSymmetric(horizontal: 8).expanded(),
                  textField(
                    text: "تعداد",
                    controller: stock,
                    onChanged: (final String p0) => subProducts[index].stock = int.parse(p0),
                  ).marginSymmetric(horizontal: 8).expanded(),
                  if (index == subProducts.length - 1)
                    const Icon(Icons.add).onTap(() {
                      subProducts.add(ProductCreateUpdateDto());
                    }),
                  if (index != subProducts.length - 1)
                    const Icon(Icons.remove).onTap(() {
                      final ProductCreateUpdateDto sub = subProducts[index];
                      if (!deletedSubProducts.map((final ProductCreateUpdateDto element) => element.id).toList().contains(sub.id)) deletedSubProducts.add(sub);
                      subProducts.remove(subProducts[index]);
                    }),
                ],
              ),
            );
          }).toList(),
        ),
      );
}
