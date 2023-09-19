import 'package:utilities/utilities.dart';

class StorageInfoCard extends StatelessWidget {
  const StorageInfoCard({
    required this.title,
    required this.svgSrc,
    required this.amountOfFiles,
    required this.numOfFiles,
    final Key? key,
  }) : super(key: key);

  final String title;
  final String svgSrc;
  final String amountOfFiles;
  final int numOfFiles;

  @override
  Widget build(final BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: context.theme.colorScheme.primary.withOpacity(0.15)),
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 20,
              width: 20,
              child: SvgPicture.asset(svgSrc),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "$numOfFiles Files",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            Text(amountOfFiles)
          ],
        ),
      );
}
