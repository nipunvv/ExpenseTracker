import 'dart:io';
import 'package:expense_tracker/models/transaction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:csv/csv.dart';

class PdfReport {
  var i = 0;
  var result = 0;
  var formatter = new DateFormat('yyyy-MM-dd');
  final pdf = pw.Document();

  writeOnPdf(List<Transaction> txReport) {
    double totalExpense() {
      double sum = 0.0;
      for (var i = 0; i < txReport.length; i++) {
        sum = sum + txReport[i].amount;
      }
      return sum;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Text('expense report'),
            ),
            pw.Container(
                color: PdfColors.cyanAccent,
                child: pw.Table(border: pw.TableBorder(), children: [
                  pw.TableRow(children: [
                    pw.Text(
                      ' slno',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      ' Category',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      ' Title',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      ' Amount',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      ' Date',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ]),
                  for (var expense in txReport) tableRow(expense, 'All'),
                ])),
            pw.SizedBox(
              height: 40.0,
            ),
            pw.Text(' Total Expense is : ' + totalExpense().toString()),
          ];
        },
      ),
    );
    return;
  }

  pw.TableRow tableRow(var expense, String category) {
    i++;
    return pw.TableRow(children: [
      pw.Text(' ' + i.toString()),
      if (category == 'All') pw.Text(' ' + expense.category),
      pw.Text(' ' + expense.title),
      pw.Text(' ' + expense.amount.toString()),
      pw.Text(' ' + expense.date.toString())
    ]);
  }

  Future<int> savePdf() async {
    var result = 0;
    var date = new DateTime.now();
    String now = 'expense ' + date.toString() + '.pdf';
    Directory documentDirectory = await getExternalStorageDirectory();
    String documentPath = documentDirectory.path;
    String path = documentPath + '/' + now;
    print("DOCUMENT_PATH => $path");
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    var permissionResult = statuses[Permission.storage];
    if (permissionResult == PermissionStatus.granted) {
      result = 1;
      File file = File(path);
      await file.writeAsBytes(await pdf.save());
      OpenFile.open(path);
    }
    return result as int;
  }

  Future<int> getCsv(List<Transaction> txReport) async {
    var date = new DateTime.now();
    String now = ' expense ' + date.toString() + '.csv';
    Directory documentDirectory = await getExternalStorageDirectory();
    String documentPath = documentDirectory.path;
    String path = documentPath + '/' + now;
    print(documentPath);
    List<List<dynamic>> rows = List<List<dynamic>>();
    List<dynamic> row = [];
    row.add('Slno');
    row.add('Category');
    row.add('Title');
    row.add('Amount');
    row.add('Date');
    rows.add(row);
    for (int i = 0; i < txReport.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add(txReport[i].category);
      row.add(txReport[i].title);
      row.add(txReport[i].amount);
      row.add(txReport[i].date.toString());
      rows.add(row);
    }
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    var permissionResult = statuses[Permission.storage];
    if (permissionResult == PermissionStatus.granted) {
      File file = File(path);
      String csv = const ListToCsvConverter().convert(rows);
      await file.writeAsString(csv);
      OpenFile.open(path);
    }
  }
}
