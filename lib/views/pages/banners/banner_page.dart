import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/banners/banner_controller.dart';
import 'package:utilities_admin_flutter/views/widget/image_preview_page.dart';

class BannersPage extends StatefulWidget {
  const BannersPage({super.key});

  @override
  State<BannersPage> createState() => _BannersPageState();
}

class _BannersPageState extends State<BannersPage> with BannerController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        appBar: AppBar(
          title: const Text("بنر‌ها"),
          actions: <Widget>[
            if (Core.user.tags!.contains(TagUser.adminContentUpdate.number))
              IconButton(onPressed: () => create(action: () => setState(() {})), icon: const Icon(Icons.add_box_outlined, size: 40)),
          ],
        ),
        body: Obx(
          () => state.isLoaded()
              ? Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: DataTable(
                        columns: <DataColumn>[
                          DataColumn(label: const Text("ردیف").headlineSmall()),
                          DataColumn(label: const Text("تصویر").headlineSmall()),
                          DataColumn(label: const Text("عنوان").headlineSmall()),
                          DataColumn(label: const Text("توضیحات").headlineSmall()),
                          DataColumn(label: const Text("عملیات‌ها").headlineSmall()),
                        ],
                        rows: <DataRow>[
                          ...list
                              .mapIndexed(
                                (final int index, final ContentReadDto i) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(index.toString()).bodyLarge().paddingAll(8)),
                                    DataCell(
                                      Row(
                                        children: <Widget>[
                                          image(i.media.getImage(), width: 32, height: 32).onTap(() {
                                            push(ImagePreviewPage(i.media!.map((final MediaReadDto e) => e.url).toList()));
                                          }),
                                          Text(i.title ?? "").bodyLarge().paddingAll(8),
                                        ],
                                      ),
                                    ),
                                    DataCell(Text(i.title ?? "").bodyLarge().paddingAll(8)),
                                    DataCell(Text(i.description ?? "").bodyLarge().paddingAll(8)),
                                    DataCell(
                                      Row(
                                        children: <Widget>[
                                          if (Core.user.tags!.contains(TagUser.adminContentUpdate.number))
                                            IconButton(
                                              onPressed: () => delete(dto: i),
                                              icon: Icon(Icons.delete, color: context.theme.colorScheme.error),
                                            ).paddingSymmetric(horizontal: 8),
                                          if (Core.user.tags!.contains(TagUser.adminContentUpdate.number))
                                            IconButton(
                                              onPressed: () => update(dto: i, index: index, action: () {}),
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
                      ).container(width: context.width),
                    ).expanded(),
                  ],
                )
              : const CircularProgressIndicator().alignAtCenter(),
        ),
      );
}
