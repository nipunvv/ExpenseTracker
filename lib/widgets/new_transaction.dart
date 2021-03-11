import 'package:carousel_slider/carousel_slider.dart';
import 'package:expense_tracker/database/database.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final CarouselController _controller = CarouselController();
  int categoryIndex = 0;

  List<Map<String, Object>> _carousalItems = [
    {'icon': Icons.restaurant_menu, 'title': 'Food', 'color': Colors.blueGrey},
    {'icon': Icons.shopping_cart, 'title': 'Groceries', 'color': Colors.cyan},
    {'icon': Icons.train, 'title': 'Travel', 'color': Colors.blue},
    {'icon': Icons.local_mall, 'title': 'Beauty', 'color': Colors.red},
    {'icon': Icons.theaters, 'title': 'Entertainment', 'color': Colors.green},
    {'icon': Icons.whatshot, 'title': 'Other', 'color': Colors.amber},
  ];

  void submitData() {
    String enteredTitle = _titleController.text;
    double enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    String selectedCategory = _carousalItems[categoryIndex]['title'];

    Transaction transaction = Transaction(
        id: null,
        title: enteredTitle,
        amount: enteredAmount,
        category: selectedCategory,
        date: _selectedDate);

    DBProvider.db.newTransaction(transaction);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void changeCategory(direction) {
    if (direction == 'left') {
      setState(() {
        categoryIndex =
            categoryIndex == 0 ? _carousalItems.length - 1 : categoryIndex - 1;
      });
      _controller.previousPage();
    } else {
      setState(() {
        categoryIndex =
            categoryIndex == _carousalItems.length - 1 ? 0 : categoryIndex + 1;
      });
      _controller.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 0,
        child: Container(
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 70,
                child: Row(
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'No Date Chosen'
                          : DateFormat('dd-MM-yyyy').format(_selectedDate),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.event,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                      ),
                      onTap: _presentDatePicker,
                    )
                  ],
                ),
              ),
              Stack(
                children: [
                  CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                      height: 80.0,
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      disableCenter: true,
                      aspectRatio: 2.0,
                    ),
                    items: _carousalItems.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              // width: 60.0,
                              margin: EdgeInsets.symmetric(horizontal: 0),
                              // decoration: BoxDecoration(color: Colors.amber),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 100.0,
                                      child: CircleAvatar(
                                        backgroundColor: item['color'],
                                        child: Container(
                                          margin: EdgeInsets.all(5.0),
                                          child: Icon(
                                            item['icon'],
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(item['title'])
                                ],
                              ));
                        },
                      );
                    }).toList(),
                  ),
                  Positioned(
                    left: 0,
                    top: 10,
                    child: TextButton(
                      onPressed: () => changeCategory('left'),
                      child: Icon(Icons.chevron_left),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 10,
                    child: TextButton(
                      onPressed: () => changeCategory('right'),
                      child: Icon(Icons.chevron_right),
                    ),
                  ),
                ],
              ),
              TextField(
                decoration: InputDecoration(labelText: 'title'),
                controller: _titleController,
                textInputAction: TextInputAction.go,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
                textInputAction: TextInputAction.go,
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: RaisedButton(
                  child: Text(
                    'Add Transaction',
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: submitData,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
