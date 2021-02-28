import 'package:expense_tracker/redux/store.dart';
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
  List<Map<String, Object>> _txTypes = [
    {'icon': Icons.restaurant_menu, 'title': 'Food', 'color': Colors.purple},
    {'icon': Icons.shopping_cart, 'title': 'Groceries', 'color': Colors.cyan},
    {'icon': Icons.train, 'title': 'Travel', 'color': Colors.blue},
    {'icon': Icons.local_mall, 'title': 'Beauty', 'color': Colors.red},
    {'icon': Icons.theaters, 'title': 'Entertainment', 'color': Colors.green},
    {'icon': Icons.whatshot, 'title': 'Other', 'color': Colors.amber},
  ];

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      builder: (_) {
        return GestureDetector(
          child: NewTransaction(),
          onTap: () {},
        );
      },
    );
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
                itemBuilder: (context, index) => Card(
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
                    subtitle: Text(
                      'Monthly total comes here',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
