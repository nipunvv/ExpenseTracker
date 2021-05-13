import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/redux/store.dart';
import 'package:expense_tracker/redux/tx-report/tx_report_action.dart';
import 'package:expense_tracker/uitls/page_utils.dart';
import 'package:expense_tracker/uitls/tx_utils.dart';
import 'package:expense_tracker/widgets/pdf_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

const CURRENT_PAGE = 2;

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  List<Map<String, Object>> _carousalItems = transactionTypes;
  int _categoryIndex = 0;
  final CarouselController _controller = CarouselController();
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  bool showGetReport = true;

  @override
  void dispose() {
    super.dispose();
    Redux.store.dispatch(resetReport());
  }

  @override
  void initState() {
    super.initState();
    _carousalItems
        .insert(0, {'icon': null, 'title': 'All', 'color': Colors.brown});
  }

  void _changeCategory(index) {
    _controller.jumpToPage(index);
  }

  String getFromDate() {
    return DateFormat('MMM yyyy').format(selectedFromDate);
  }

  String getToDate() {
    return DateFormat('MMM yyyy').format(selectedToDate);
  }

  void selectDate(String which) {
    showMonthPicker(
      context: context,
      firstDate: which == 'from'
          ? DateTime(DateTime.now().year - 1, 1)
          : DateTime(selectedFromDate.year, selectedFromDate.month),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month),
      initialDate: (which == 'from' ? selectedFromDate : selectedToDate) ??
          DateTime.now(),
      locale: Locale("en"),
    ).then((date) {
      if (date != null) {
        setState(() {
          which == 'from' ? selectedFromDate = date : selectedToDate = date;
        });
      }
    });
  }

  void getReport() {
    if (!showGetReport) {
      setState(() {
        showGetReport = true;
      });
      return;
    }
    setState(() {
      showGetReport = false;
    });

    String category = 'All';
    for (int i = 0; i < _carousalItems.length; i++) {
      if (i == _categoryIndex) {
        category = _carousalItems[i]['title'];
      }
    }
    Redux.store.dispatch(fetchTxReportAction(
        Redux.store, selectedFromDate, selectedToDate, category));
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  void _showExportDialog(List<Transaction> txReport) {
    showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return SimpleDialog(
          title: Text('Export Report'),
          children: [
            SimpleDialogOption(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 7),
                child: Text(
                  'Export to PDF',
                ),
              ),
              onPressed: () {
                PdfReport pdfReport = PdfReport();
                pdfReport.writeOnPdf(txReport);
                pdfReport.savePdf();
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Container(
                height: 30,
                padding: EdgeInsets.symmetric(vertical: 7),
                child: Text(
                  'Export to Excel',
                ),
              ),
              onPressed: () {
                PdfReport pdfReport = PdfReport();
                pdfReport.writeOnPdf(txReport);
                pdfReport.getCsv(txReport);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Reports',
          ),
        ],
        currentIndex: CURRENT_PAGE,
        selectedItemColor: Colors.purple,
        onTap: (index) => navigateToPage(CURRENT_PAGE, index, context),
      ),
      body: Container(
        child: Column(
          children: [
            if (showGetReport)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => selectDate('from'),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.only(left: 20),
                      decoration: new BoxDecoration(
                        color: Color(0xFFEAF3FF),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.event),
                          SizedBox(
                            width: 10,
                          ),
                          Text(getFromDate()),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => selectDate('to'),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFFEAF3FF),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.event),
                          SizedBox(
                            width: 10,
                          ),
                          Text(getToDate()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (showGetReport)
              Container(
                margin: EdgeInsets.only(top: 20),
                child: CarouselSlider(
                  carouselController: _controller,
                  options: CarouselOptions(
                    height: 100.0,
                    viewportFraction: 0.3,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    disableCenter: true,
                    aspectRatio: 2.0,
                    initialPage: _categoryIndex,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _categoryIndex = index;
                      });
                    },
                  ),
                  items: _carousalItems.asMap().entries.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Transform.scale(
                          scale: item.key == _categoryIndex ? 1 : 0.6,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _changeCategory(item.key),
                                    child: Container(
                                      width: 100.0,
                                      child: CircleAvatar(
                                        backgroundColor: item.value['color'],
                                        child: Container(
                                          margin: EdgeInsets.all(5.0),
                                          child: item.value['icon'] != null
                                              ? Icon(
                                                  item.value['icon'],
                                                  color: Colors.white,
                                                )
                                              : Text(
                                                  'All',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  item.value['title'],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            Row(
              children: [
                if (!showGetReport)
                  StoreConnector<AppState, List<Transaction>>(
                      converter: (store) => store.state.txReportState.txReport,
                      builder: (context, txReport) {
                        return GestureDetector(
                          onTap: () => _showExportDialog(txReport),
                          child: Container(
                            height: 50,
                            margin:
                                EdgeInsets.only(top: 20, left: 20, bottom: 30),
                            padding: EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                              color: Color(0xFFC7F6B6),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Export Report'),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.file_upload),
                              ],
                            ),
                          ),
                        );
                      }),
                Spacer(),
                GestureDetector(
                  onTap: getReport,
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.only(top: 20, right: 20, bottom: 30),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE3E0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(showGetReport ? 'Get Report' : 'New Report'),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: StoreConnector<AppState, List<Transaction>>(
                converter: (store) => store.state.txReportState.txReport,
                builder: (context, txReport) {
                  if (txReport.length > 0) {
                    return Expanded(
                      child: ListView(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Text('Category'),
                                ),
                                DataColumn(
                                  label: Text('Title'),
                                ),
                                DataColumn(
                                  label: Text('Amount'),
                                  numeric: true,
                                ),
                                DataColumn(
                                  label: Text('Date'),
                                ),
                              ],
                              rows: txReport.map((item) {
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text(item.category),
                                    ),
                                    DataCell(
                                      Text(item.title),
                                    ),
                                    DataCell(
                                      Text(
                                        item.amount.toStringAsFixed(1),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        formatDate(item.date),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Expanded(
                    child: Center(
                      child: Container(
                        child: Text(showGetReport ? '' : 'No Data Available'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
