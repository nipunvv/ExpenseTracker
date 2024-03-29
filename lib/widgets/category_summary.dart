import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/redux/store.dart';
import 'package:expense_tracker/redux/transaction/tx_action.dart';
import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class CategorySummary extends StatefulWidget {
  final title, icon, color, date;
  CategorySummary({this.title, this.icon, this.color, this.date});

  @override
  _CategorySummaryState createState() => _CategorySummaryState();
}

class _CategorySummaryState extends State<CategorySummary> {
  @override
  void initState() {
    super.initState();
    Redux.store.dispatch(fetchTransactionsAction(widget.title, widget.date));
  }

  void editTransaction(BuildContext ctx, Transaction transaction) {
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
            child: NewTransaction(
              transaction: transaction,
              addingCategory: '',
            ),
            onTap: () {},
          ),
        );
      },
    );
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
            child: NewTransaction(
              addingCategory: widget.title,
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  isViewingSameMonthData() {
    String currentMMYY = DateFormat('MM-YY').format(DateTime.now());
    String selectedMMYY = DateFormat('MM-YY').format(widget.date);
    return currentMMYY == selectedMMYY;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: isViewingSameMonthData()
          ? FloatingActionButton(
              onPressed: () => startAddNewTransaction(context),
              child: const Icon(Icons.add),
              backgroundColor: Colors.green,
            )
          : Container(),
      body: Container(
        child: StoreConnector<AppState, List<Transaction>>(
          converter: (store) => store.state.txState.transactions,
          builder: (context, transactions) {
            if (transactions.length > 0) {
              return ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) => GestureDetector(
                  child: Card(
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
                      title: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                DateFormat('yyyy-MM-dd')
                                    .format(transactions[index].date),
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                transactions[index].title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(
                        '₹ ' + transactions[index].amount.toString(),
                      ),
                    ),
                  ),
                  onTap: () => editTransaction(context, transactions[index]),
                ),
              );
            }
            return Center(
              child: Text(
                "No transaction for ${widget.title} yet",
              ),
            );
          },
        ),
      ),
    );
  }
}
