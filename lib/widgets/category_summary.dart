import 'package:expense_tracker/database/database.dart';
import 'package:flutter/material.dart';

class CategorySummary extends StatefulWidget {
  final title, icon, color;
  CategorySummary({this.title, this.icon, this.color});

  @override
  _CategorySummaryState createState() => _CategorySummaryState();
}

class _CategorySummaryState extends State<CategorySummary> {
  var _transactions;
  @override
  void initState() {
    super.initState();
    _transactions = DBProvider.db.getSummaryByCategory(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _transactions,
          builder: (_, transactionData) {
            switch (transactionData.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Container();
              case ConnectionState.active:
              case ConnectionState.done:
                return ListView.builder(
                  itemCount: transactionData.data.length,
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
                      title: Text(
                        transactionData.data[index]['date'],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Text(
                        transactionData.data[index]['amount'].toString(),
                      ),
                    ),
                  ),
                );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
