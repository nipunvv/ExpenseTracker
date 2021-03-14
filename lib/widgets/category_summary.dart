import 'package:expense_tracker/database/database.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/redux/store.dart';
import 'package:expense_tracker/redux/transaction/tx_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class CategorySummary extends StatefulWidget {
  final title, icon, color;
  CategorySummary({this.title, this.icon, this.color});

  @override
  _CategorySummaryState createState() => _CategorySummaryState();
}

class _CategorySummaryState extends State<CategorySummary> {
  @override
  void initState() {
    super.initState();
    Redux.store.dispatch(fetchTransactionsAction(Redux.store, widget.title));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: StoreConnector<AppState, List<Transaction>>(
          converter: (store) => store.state.txState.transactions,
          builder: (context, transactions) {
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) => Card(
                elevation: 0,
                margin: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: widget.color,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Icon(
                          widget.icon,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        transactions[index].title,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd')
                            .format(transactions[index].date),
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '₹ ' + transactions[index].amount.toString(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
