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

Widget dataTableImage(final String url) => image(url, width: 40, height: 40).onTap(() => launchURL(url));
