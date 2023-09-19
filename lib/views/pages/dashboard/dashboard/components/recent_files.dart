import 'package:utilities/utilities.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
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
            Text(
              "Recent Files",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columnSpacing: 16,
                // minWidth: 600,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text("File Name"),
                  ),
                  DataColumn(
                    label: Text("Date"),
                  ),
                  DataColumn(
                    label: Text("Size"),
                  ),
                ],
                rows: List<DataRow>.generate(
                  demoRecentFiles.length,
                  (final int index) => recentFileDataRow(demoRecentFiles[index]),
                ),
              ),
            ),
          ],
        ),
      );
}

DataRow recentFileDataRow(final RecentFile fileInfo) => DataRow(
      cells: <DataCell>[
        DataCell(
          Row(
            children: <Widget>[
              SvgPicture.asset(
                fileInfo.icon!,
                height: 30,
                width: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(fileInfo.title!),
              ),
            ],
          ),
        ),
        DataCell(Text(fileInfo.date!)),
        DataCell(Text(fileInfo.size!)),
      ],
    );

class RecentFile {
  RecentFile({this.icon, this.title, this.date, this.size});

  final String? icon;
  final String? title;
  final String? date;
  final String? size;
}

List<RecentFile> demoRecentFiles = <RecentFile>[
  RecentFile(icon: "lib/assets/icons/xd_file.svg", title: "XD File", date: "01-03-2021", size: "3.5mb"),
  RecentFile(icon: "lib/assets/icons/Figma_file.svg", title: "Figma File", date: "27-02-2021", size: "19.0mb"),
  RecentFile(icon: "lib/assets/icons/doc_file.svg", title: "Document", date: "23-02-2021", size: "32.5mb"),
  RecentFile(icon: "lib/assets/icons/sound_file.svg", title: "Sound File", date: "21-02-2021", size: "3.5mb"),
  RecentFile(icon: "lib/assets/icons/media_file.svg", title: "Media File", date: "23-02-2021", size: "2.5gb"),
  RecentFile(icon: "lib/assets/icons/pdf_file.svg", title: "Sales PDF", date: "25-02-2021", size: "3.5mb"),
  RecentFile(icon: "lib/assets/icons/excel_file.svg", title: "Excel File", date: "25-02-2021", size: "34.5mb"),
];
