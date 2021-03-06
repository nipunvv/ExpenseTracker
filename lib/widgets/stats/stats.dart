import 'package:expense_tracker/models/transaction_summary.dart';
import 'package:expense_tracker/redux/store.dart';
import 'package:expense_tracker/redux/tx-summary/tx_summary_action.dart';
import 'package:expense_tracker/uitls/page_utils.dart';
import 'package:expense_tracker/widgets/stats/indicator_container.dart';
import 'package:expense_tracker/widgets/stats/pie_chart.dart';
import 'package:expense_tracker/widgets/stats/bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

const CURRENT_PAGE = 1;

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  bool isPiechart = false;
  final PageController pageController = PageController(initialPage: 0);
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Redux.store.dispatch(fetchTxSummaryAction(selectedDate));
  }

  @override
  void dispose() {
    super.dispose();
    Redux.store.dispatch(fetchTxSummaryAction(DateTime.now()));
  }

  String getTotalExpense(List<TransactionSummary> txSummary) {
    double totalExpense = 0.0;
    txSummary.forEach((summary) {
      totalExpense += summary.amount != null ? summary.amount : 0.0;
    });
    return totalExpense.toStringAsFixed(2);
  }

  void selectDate() {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 1),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month),
      initialDate: selectedDate,
      locale: Locale("en"),
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
          Redux.store.dispatch(fetchTxSummaryAction(selectedDate));
        });
      }
    });
  }

  String getFormattedDate() {
    return DateFormat('MMM yyyy').format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
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
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.amber,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getFormattedDate(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.event),
                          onPressed: selectDate,
                        )
                      ],
                    ),
                    StoreConnector<AppState, List<TransactionSummary>>(
                      distinct: true,
                      converter: (store) =>
                          store.state.txSummaryState.txSummary,
                      builder: (context, txSummary) {
                        if (txSummary.length > 0) {
                          return Text(
                            'Total Expense: ₹ ${getTotalExpense(txSummary)}',
                          );
                        }
                        return Text('Total Expense: ₹ 0.0');
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              color: const Color(0xff81e5cd),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.bar_chart,
                          color: isPiechart ? Colors.black : Colors.white,
                        ),
                        onPressed: () {
                          pageController.animateToPage(
                            0,
                            curve: Curves.linear,
                            duration: Duration(milliseconds: 300),
                          );
                          setState(() {
                            isPiechart = false;
                          });
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.donut_large,
                          color: isPiechart ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          pageController.animateToPage(
                            1,
                            curve: Curves.linear,
                            duration: Duration(milliseconds: 300),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  IndicatorContainer(),
                  StoreConnector<AppState, List<TransactionSummary>>(
                    distinct: true,
                    converter: (store) => store.state.txSummaryState.txSummary,
                    builder: (context, txSummary) {
                      if (txSummary.length > 0) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: PageView(
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (value) {
                              setState(() {
                                isPiechart = value == 0 ? false : true;
                              });
                            },
                            children: [
                              SummaryBarChart(txSummary),
                              SummaryPieChart(txSummary),
                            ],
                          ),
                        );
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Text(
                            'No Transaction found for this month',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
