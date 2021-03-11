import 'package:expense_tracker/database/database.dart';
import 'package:expense_tracker/redux/store.dart';
import 'package:expense_tracker/widgets/category_summary.dart';
import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
        ));
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
  Future _transactionSummary;

  List<Map<String, Object>> _txTypes = [
    {'icon': Icons.restaurant_menu, 'title': 'Food', 'color': Colors.blueGrey},
    {'icon': Icons.shopping_cart, 'title': 'Groceries', 'color': Colors.cyan},
    {'icon': Icons.train, 'title': 'Travel', 'color': Colors.blue},
    {'icon': Icons.local_mall, 'title': 'Beauty', 'color': Colors.red},
    {'icon': Icons.theaters, 'title': 'Entertainment', 'color': Colors.green},
    {'icon': Icons.whatshot, 'title': 'Other', 'color': Colors.amber},
  ];

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
    _transactionSummary = DBProvider.db.getMonthSummary();
  }

  getTransactions() async {
    final _transactions = DBProvider.db.getTransactions();
    return _transactions;
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                      subtitle: FutureBuilder(
                        future: _transactionSummary,
                        builder: (_, transactionData) {
                          switch (transactionData.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return Text('0.0');
                            case ConnectionState.active:
                            case ConnectionState.done:
                              return Text(
                                  (transactionData.data[index]['amount'] ?? 0.0)
                                      .toString());
                          }
                          return Text('');
                        },
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategorySummary(
                                  title: _txTypes[index]['title'],
                                  icon: _txTypes[index]['icon'],
                                  color: _txTypes[index]['color'],
                                )));
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
