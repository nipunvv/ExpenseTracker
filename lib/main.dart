import 'package:expense_tracker/database/database.dart';
import 'package:expense_tracker/models/transaction_summary.dart';
import 'package:expense_tracker/redux/store.dart';
import 'package:expense_tracker/redux/tx-summary/tx_summary_action.dart';
import 'package:expense_tracker/uitls/date_utils.dart';
import 'package:expense_tracker/uitls/tx_utils.dart';
import 'package:expense_tracker/widgets/category_summary.dart';
import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:expense_tracker/widgets/stats/stats.dart';
import 'package:expense_tracker/widgets/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

void main() async {
  await Redux.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpenseTracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                button: TextStyle(
                  color: Colors.white,
                ),
              ),
        ),
      ),
      home: StoreProvider<AppState>(
        store: Redux.store,
        child: MyHomePage(
          title: 'ExpenseTracker',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, String> transaction = {};

  List<Map<String, Object>> _txTypes = transactionTypes;

  void _onItemTapped(int index) {
    if (index != 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => index == 1
              ? StoreProvider<AppState>(
                  store: Redux.store,
                  child: Stats(),
                )
              : Reports(),
        ),
        ModalRoute.withName('/'),
      );
    }
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      isScrollControlled: true,
      builder: (_) {
        return SingleChildScrollView(
          child: GestureDetector(
            child: NewTransaction(),
            onTap: () {},
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Redux.store.dispatch(fetchTxSummaryAction);
  }

  getTransactions() async {
    final _transactions = DBProvider.db.getTransactions();
    return _transactions;
  }

  String getTotalExpense(List<TransactionSummary> txSummary) {
    double totalExpense = 0.0;
    txSummary.forEach((summary) {
      totalExpense += summary.amount != null ? summary.amount : 0.0;
    });
    return totalExpense.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => startAddNewTransaction(context),
          ),
        ],
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
        currentIndex: 0,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 100,
              width: double.infinity,
              child: Card(
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
                            getMonthAndYear(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.event),
                            onPressed: () {},
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
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 600,
              child: ListView.builder(
                itemCount: _txTypes.length,
                itemBuilder: (context, index) => GestureDetector(
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: _txTypes[index]['color'],
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: FittedBox(
                            child: Icon(
                              _txTypes[index]['icon'],
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        _txTypes[index]['title'],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle:
                          StoreConnector<AppState, List<TransactionSummary>>(
                        distinct: true,
                        converter: (store) =>
                            store.state.txSummaryState.txSummary,
                        builder: (context, txSummary) {
                          if (txSummary.length > 0) {
                            return Text(
                              '₹ ' +
                                  (txSummary[index].amount ?? 0.0).toString(),
                            );
                          } else {
                            return Text('₹ 0.0');
                          }
                        },
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoreProvider<AppState>(
                          store: Redux.store,
                          child: CategorySummary(
                            title: _txTypes[index]['title'],
                            icon: _txTypes[index]['icon'],
                            color: _txTypes[index]['color'],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
