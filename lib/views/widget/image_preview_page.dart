import 'package:utilities/utilities.dart';

class ImagePreviewPage extends StatefulWidget {
  const ImagePreviewPage(this.list, {this.currentIndex, super.key});

  final List<String> list;
  final int? currentIndex;

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  int index = 0;

  double progress = 0;
  PageController controller = PageController();

  @override
  void initState() {
    index = widget.currentIndex ?? 0;
    controller = PageController(initialPage: index);
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
        appBar: AppBar(backgroundColor: context.theme.splashColor),
        body: widget.list.length > 1
            ? Column(
                children: <Widget>[
                  Expanded(
                    child: PageView.builder(
                      itemCount: widget.list.length,
                      controller: controller,
                      itemBuilder: (final BuildContext context, final int index) => Container(
                        color: context.theme.scaffoldBackgroundColor,
                        child: Center(
                          child: image(
                            widget.list[index],
                            fit: BoxFit.cover,
                            borderRadius: 16,
                            width: Get.width,
                          ).marginSymmetric(horizontal: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: image(
                  widget.list.first,
                  fit: BoxFit.cover,
                  borderRadius: 16,
                  width: Get.width,
                ).marginSymmetric(horizontal: 20),
              ),
      );
}
