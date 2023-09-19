import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/dashboard/dashboard/components/my_fields.dart';

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    required this.info, final Key? key,
  }) : super(key: key);

  final CloudStorageInfo info;

  @override
  Widget build(final BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16 * 0.75),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: info.color!.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SvgPicture.asset(
                    info.svgSrc!,
                    colorFilter: ColorFilter.mode(info.color ?? Colors.black, BlendMode.srcIn),
                  ),
                ),
                const Icon(Icons.more_vert, color: Colors.white54)
              ],
            ),
            Text(
              info.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            ProgressLine(
              color: info.color,
              percentage: info.percentage,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "${info.numOfFiles} Files",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white70),
                ),
                Text(
                  info.totalStorage!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                ),
              ],
            )
          ],
        ),
      );
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    required this.percentage,
    final Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(final BuildContext context) => Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 5,
            decoration: BoxDecoration(
              color: (color ?? context.theme.colorScheme.primary).withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
          LayoutBuilder(
            builder: (final BuildContext context, final BoxConstraints constraints) => Container(
              width: constraints.maxWidth * (percentage! / 100),
              height: 5,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
        ],
      );
}
