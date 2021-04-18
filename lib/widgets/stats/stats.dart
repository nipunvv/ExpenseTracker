import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/redux/store.dart';
import 'package:expense_tracker/widgets/stats/pie_chart.dart';
import 'package:expense_tracker/widgets/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  void _onItemTapped(index) {
    if (index != 1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                index == 0 ? MyApp() : Reports()),
        ModalRoute.withName('/'),
      );
    }
  }

  String getMonthAndYear() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM, yyyy');
    final String formatted = formatter.format(now);
    return formatted;
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
        currentIndex: 1,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 10,
              ),
              child: Text(
                getMonthAndYear(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            StoreProvider<AppState>(
              store: Redux.store,
              child: SummaryPieChart(),
            ),
          ],
        ),
      ),
    );
  }
}
