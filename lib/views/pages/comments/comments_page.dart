import 'package:utilities/components/pagination.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/comments/comments_controller.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> with CommentsController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        appBar: AppBar(title: const Text("نظرات")),
        body: Obx(
          () => state.isLoaded()
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _filters(),
                      DataTable(
                        columns: <DataColumn>[
                          DataColumn(label: const Text("ردیف").headlineSmall()),
                          DataColumn(label: const Text("کاربر").headlineSmall()),
                          DataColumn(label: const Text("محصول").headlineSmall()),
                          DataColumn(label: const Text("نظر").headlineSmall()),
                          DataColumn(label: const Text("وضعیت").headlineSmall()),
                          // if (Core.user.tags!.contains(TagUser.adminCommentUpdate.number))
                          DataColumn(label: const Text("عملیات‌ها").headlineSmall()),
                        ],
                        rows: <DataRow>[
                          ...list.mapIndexed(
                            (final int index, final CommentReadDto i) {//
                              final Rx<TagComment> selectedCommentTag = TagComment.inQueue.obs;
                              if (i.tags!.contains(TagComment.inQueue.number)) selectedCommentTag(TagComment.inQueue);
                              if (i.tags!.contains(TagComment.rejected.number)) selectedCommentTag(TagComment.rejected);
                              if (i.tags!.contains(TagComment.released.number)) selectedCommentTag(TagComment.released);
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(index.toString()).bodyLarge().paddingAll(8)),
                                  DataCell(Text(i.user?.firstName ?? "").bodyLarge().paddingAll(8)),
                                  DataCell(Text(i.user?.firstName ?? "").bodyLarge().paddingAll(8)),
                                  DataCell(Text(i.comment ?? "").bodyLarge().paddingAll(8)),
                                  DataCell(Text(UtilitiesTagUtils.tagCommentsTitleFromTagList(i.tags!)).bodyLarge().paddingAll(8)),
                                  // if (Core.user.tags!.contains(TagUser.adminCommentUpdate.number))
                                  DataCell(
                                    Row(
                                      children: <Widget>[
                                        IconButton(
                                          onPressed: () => delete(dto: i),
                                          icon: Icon(Icons.delete, color: context.theme.colorScheme.error),
                                        ).paddingSymmetric(horizontal: 8),
                                        DropdownButtonFormField<TagComment>(
                                          value: selectedCommentTag.value,
                                          items: <DropdownMenuItem<TagComment>>[
                                            DropdownMenuItem<TagComment>(
                                              value: TagComment.released,
                                              child: Text(TagComment.released.title),
                                            ),
                                            DropdownMenuItem<TagComment>(
                                              value: TagComment.rejected,
                                              child: Text(TagComment.rejected.title),
                                            ),
                                            DropdownMenuItem<TagComment>(
                                              value: TagComment.inQueue,
                                              child: Text(TagComment.inQueue.title),
                                            ),
                                          ],
                                          onChanged: (final TagComment? value) {
                                            selectedCommentTag(value);
                                            update(dto: CommentCreateUpdateDto(id: i.id, tags: <int>[value!.number]));
                                          },
                                        ).container(width: 15),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ).toList(),
                        ],
                      ).container(width: context.width),
                      Pagination(
                        numOfPages: pageCount,
                        selectedPage: pageNumber,
                        pagesVisible: pageCount,
                        onPageChanged: (final int index) {
                          pageNumber = index;
                          read();
                        },
                      ),
                    ],
                  ),
                )
              : const CircularProgressIndicator().alignAtCenter(),
        ),
      );

  Widget _filters() => Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          DropdownButtonFormField<int>(
            value: selectedCommentTag.value,
            items: <DropdownMenuItem<int>>[
              DropdownMenuItem<int>(value: TagComment.all.number, child: const Text("همه")),
              DropdownMenuItem<int>(value: TagComment.released.number, child: const Text("منتشر شده")),
              DropdownMenuItem<int>(value: TagComment.rejected.number, child: const Text("رد شده")),
              DropdownMenuItem<int>(value: TagComment.inQueue.number, child: const Text("در انتظار بررسی")),
            ],
            onChanged: selectedCommentTag,
          ).container(width: 200, margin: const EdgeInsets.all(8)),
          button(title: "فیلتر", onTap: read, width: 200),
        ],
      );
}
