import 'package:utilities/utilities.dart';

Widget dataTable({
  required final List<Widget> columns,
  required final List<Widget> rows,
}) =>
    DataTable(columns: columns.map((final Widget e) => DataColumn(label: e)).toList(), rows: columns.map((final Widget e) => DataRow(cells: rows.map(DataCell.new).toList())).toList());
