import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/redux/store.dart';
import 'package:expense_tracker/widgets/stats/stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  void _onItemTapped(index) {
    if (index != 2) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => index == 0
              ? MyApp()
              : StoreProvider<AppState>(
                  store: Redux.store,
                  child: Stats(),
                ),
        ),
        ModalRoute.withName('/'),
      );
    }
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
        currentIndex: 2,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
      body: Container(),
    );
  }
}
