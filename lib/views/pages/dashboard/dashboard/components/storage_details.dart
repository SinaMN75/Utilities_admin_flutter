import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/dashboard/dashboard/components/storage_info_card.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    final Key? key,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Storage Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            doughnutChart(
              data: <DoughnutChartData>[
                DoughnutChartData("iphone", 50),
                DoughnutChartData("android", 30),
                DoughnutChartData("mac", 70),
                DoughnutChartData("windows", 120),
              ],
            ),
            const StorageInfoCard(
              svgSrc: "lib/assets/icons/Documents.svg",
              title: "Documents Files",
              amountOfFiles: "1.3GB",
              numOfFiles: 1328,
            ),
            const StorageInfoCard(
              svgSrc: "lib/assets/icons/media.svg",
              title: "Media Files",
              amountOfFiles: "15.3GB",
              numOfFiles: 1328,
            ),
            const StorageInfoCard(
              svgSrc: "lib/assets/icons/folder.svg",
              title: "Other Files",
              amountOfFiles: "1.3GB",
              numOfFiles: 1328,
            ),
            const StorageInfoCard(
              svgSrc: "lib/assets/icons/unknown.svg",
              title: "Unknown",
              amountOfFiles: "1.3GB",
              numOfFiles: 140,
            ),
          ],
        ),
      );
}
