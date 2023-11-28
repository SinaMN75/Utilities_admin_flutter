import 'package:excel/excel.dart';
import 'package:utilities/utilities.dart';

void exportToExcel({required final List<CategoryReadDto> list}) {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel[excel.getDefaultSheet()!];

  list.asMap().forEach((final int index, final CategoryReadDto i) {
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: index)).value = TextCellValue(i.title ?? "");
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: index)).value = TextCellValue(i.titleTr1 ?? "");
  });

  excel.save(fileName: "MyData.xlsx");
}
