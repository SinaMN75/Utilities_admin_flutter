import 'package:utilities/components/pagination.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/comments/comments_controller.dart';
import 'package:utilities_admin_flutter/views/widget/table.dart';
import 'package:utilities_admin_flutter/views/widget/widgets.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({this.userId, super.key});

  final String? userId;

  @override
  Key? get key => const Key("کامنت ها");

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> with CommentsController, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    userId = widget.userId;
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return scaffold(
      constraints: const BoxConstraints(),
      appBar: AppBar(),
      body: Obx(
        () => state.isLoaded()
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _filters(),
                    DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text("ردیف")),
                        DataColumn(label: Text("کاربر")),
                        DataColumn(label: Text("محصول")),
                        DataColumn(label: Text("نظر")),
                        DataColumn(label: Text("عملیات‌ها")),
                      ],
                      rows: <DataRow>[
                        ...list.mapIndexed(
                          (final int index, final CommentReadDto i) {
                            final Rx<TagComment> selectedCommentTag = TagComment.inQueue.obs;
                            if (i.tags.contains(TagComment.inQueue.number)) selectedCommentTag(TagComment.inQueue);
                            if (i.tags.contains(TagComment.rejected.number)) selectedCommentTag(TagComment.rejected);
                            if (i.tags.contains(TagComment.released.number)) selectedCommentTag(TagComment.released);
                            return DataRow(
                              color: dataTableRowColor(index),
                              cells: <DataCell>[
                                DataCell(Text(index.toString())),
                                DataCell(Text("${i.user?.firstName} ${i.user?.lastName}")),
                                DataCell(Text(i.product?.title ?? "")),
                                DataCell(
                                  const Text("نمایش نظر").bodyMedium(color: context.theme.primaryColor).onTap(
                                        () => dialogAlert(
                                          Text(i.comment ?? "").paddingAll(24),
                                        ),
                                      ),
                                ),
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
                                          update(
                                            dto: CommentCreateUpdateDto(id: i.id, tags: <int>[value!.number]),
                                          );
                                        },
                                      ).container(width: 200),
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
  }

  Widget _filters() => Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          textFieldUser(onUserSelected: (final UserReadDto dto) => userId = dto.id),
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
