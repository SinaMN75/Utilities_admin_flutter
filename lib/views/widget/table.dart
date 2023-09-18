import 'package:utilities/utilities.dart';

Widget dataTable({
  required final List<Widget> columns,
  required final List<Widget> rows,
}) =>
    DataTable(
      sortColumnIndex: 0,
      sortAscending: false,
      headingRowColor: MaterialStateColor.resolveWith((final Set<MaterialState> states) => context.theme.colorScheme.primaryContainer),
      headingRowHeight: 60,
      showCheckboxColumn: false,
      columns: columns.map((final Widget e) => DataColumn(label: e)).toList(),
      rows: columns.map((final Widget e) => DataRow(cells: rows.map(DataCell.new).toList())).toList()
    );
