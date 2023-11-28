import 'package:utilities/utilities.dart';

Widget dataTable({
  required final List<Widget> columns,
  required final List<Widget> rows,
}) =>
    DataTable(
      columns: columns.map((final Widget e) => DataColumn(label: e)).toList(),
      rows: columns.map((final Widget e) => DataRow(cells: rows.map(DataCell.new).toList())).toList(),
    );

MaterialStateColor dataTableRowColor(final int index) => MaterialStateColor.resolveWith(
      (final Set<MaterialState> states) => index.isOdd ? context.theme.colorScheme.primary.withOpacity(0.1) : context.theme.colorScheme.background,
    );

Widget dataTableImage(final String url, {final double width = 40, final double height = 40}) => image(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      borderRadius: 4,
    ).onTap(() => launchURL(url));
