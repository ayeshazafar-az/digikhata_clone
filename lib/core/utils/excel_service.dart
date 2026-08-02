import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExcelService {
  static Future<void> generateAndExportExcel({
    required String partyName,
    required String partyPhone,
    required List<Map<String, dynamic>> entries,
    required double totalBalance,
  }) async {
    // 1. Create a new Excel Document
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    excel.setDefaultSheet('Sheet1');

    // 2. Add Header info
    sheetObject.appendRow([TextCellValue('DigiKhata Export')]);
    sheetObject.appendRow([TextCellValue('Party Name: $partyName')]);
    sheetObject.appendRow([TextCellValue('Phone: $partyPhone')]);
    sheetObject.appendRow([
      TextCellValue(
          'Total Balance: Rs. ${totalBalance.abs()} (${totalBalance >= 0 ? "You Got" : "You Gave"})')
    ]);
    sheetObject.appendRow([TextCellValue('')]); // Blank row

    // 3. Add Table Headers
    sheetObject.appendRow([
      TextCellValue('Date'),
      TextCellValue('Details'),
      TextCellValue('Type'),
      TextCellValue('Amount (Rs)')
    ]);

    // 4. Add Rows
    for (var entry in entries) {
      final date = entry['created_at'].toString().split('T').first;
      final type = entry['entry_type'] == 'credit'
          ? 'Cash In (You Got)'
          : 'Cash Out (You Gave)';

      sheetObject.appendRow([
        TextCellValue(date),
        TextCellValue(entry['details'] ?? 'No Note'),
        TextCellValue(type),
        DoubleCellValue(entry['amount']),
      ]);
    }

    // 5. Save the file locally
    var fileBytes = excel.save();
    if (fileBytes != null) {
      // Create a temporary file path
      final directory = await getTemporaryDirectory();
      final sanitizedName = partyName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      final path = '${directory.path}/${sanitizedName}_Ledger.xlsx';

      File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      // 6. Spawn the native share sheet to let the user save or send it
      await Share.shareXFiles([XFile(path)],
          text: 'Ledger report for $partyName');
    }
  }
}
