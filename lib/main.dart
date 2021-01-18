import 'package:flutter/material.dart';

void main() {
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
      home: MyHomePage(
        title: 'ExpenseTracker',
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
  List<Map<String, Object>> _txTypes = [
    {'icon': Icons.shopping_cart, 'title': 'Groceries'},
    {'icon': Icons.train, 'title': 'Travel'},
    {'icon': Icons.shopping_basket, 'title': 'Beauty'},
    {'icon': Icons.theaters, 'title': 'Entertainment'},
    {'icon': Icons.whatshot, 'title': 'Other'},
  ];

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
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 500,
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Icon(
                            _txTypes[index]['icon'],
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
