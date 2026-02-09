import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import '../models/expense.dart';

class ExportService {
  static Future<String?> exportToCSV(
    List<Expense> expenses,
    String fileName,
  ) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        if (await Permission.manageExternalStorage.isRestricted) {
          await Permission.storage.request();
        } else {
          await Permission.manageExternalStorage.request();
          await Permission.storage.request();
        }
      }

      List<List<dynamic>> rows = [];
      // Header
      rows.add(['ID', 'Date', 'Category', 'Amount', 'Type', 'Note']);

      for (var expense in expenses) {
        rows.add([
          expense.id,
          DateFormat('yyyy-MM-dd HH:mm').format(expense.date),
          expense.category,
          expense.amount,
          expense.isExpense ? 'Expense' : 'Income',
          expense.note,
        ]);
      }

      String csvData = const ListToCsvConverter().convert(rows);

      final directory = await _getExportDirectory();
      if (directory == null) return 'Could not find export directory';

      final file = File(p.join(directory.path, '$fileName.csv'));
      await file.writeAsString(csvData);

      return 'File saved to: ${file.path}';
    } catch (e) {
      print('Error: $e');
      return 'Error: $e';
    }
  }

  static Future<String?> exportToPDF(
    List<Expense> expenses,
    String fileName,
    DateTime start,
    DateTime end,
  ) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        if (await Permission.manageExternalStorage.isRestricted) {
          await Permission.storage.request();
        } else {
          await Permission.manageExternalStorage.request();
          await Permission.storage.request();
        }
      }

      final pdf = pw.Document();
      final dateRange =
          '${DateFormat('MMM dd, yyyy').format(start)} - ${DateFormat('MMM dd, yyyy').format(end)}';

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [pw.Text('Expense Report'), pw.Text(dateRange)],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['Date', 'Category', 'Type', 'Amount', 'Note'],
              data: expenses
                  .map(
                    (e) => [
                      DateFormat('MMM dd, HH:mm').format(e.date),
                      _cleanString(e.category),
                      e.isExpense ? 'Exp' : 'Inc',
                      e.amount.toStringAsFixed(2),
                      _cleanString(e.note),
                    ],
                  )
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.center,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerLeft,
              },
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  'Total Expenses: ${expenses.where((e) => e.isExpense).fold(0.0, (sum, e) => sum + e.amount).toStringAsFixed(2)}',
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  'Total Income: ${expenses.where((e) => !e.isExpense).fold(0.0, (sum, e) => sum + e.amount).toStringAsFixed(2)}',
                ),
              ],
            ),
          ],
        ),
      );

      final directory = await _getExportDirectory();
      if (directory == null) return 'Could not find export directory';

      final file = File(p.join(directory.path, '$fileName.pdf'));
      await file.writeAsBytes(await pdf.save());

      return 'File saved to: ${file.path}';
    } catch (e) {
      print('Error: $e');
      return 'Error: $e';
    }
  }

  static Future<Directory?> _getExportDirectory() async {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return await getDownloadsDirectory();
    } else {
      // For mobile, Downloads directory is tricky. Use application documents as fallback
      // but the user explicitly asked for 'Download' folder.
      // On Android we can use /storage/emulated/0/Download
      if (Platform.isAndroid) {
        return Directory('/storage/emulated/0/Download');
      }
      return await getApplicationDocumentsDirectory();
    }
  }

  static String _cleanString(String input) {
    // PDF Helvetica doesn't support many Unicode chars like Indian Rupee symbol
    // Strip or replace them to avoid crash
    return input.replaceAll(RegExp(r'[^\x00-\x7F]'), '');
  }
}
