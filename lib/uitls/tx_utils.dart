import 'package:expense_tracker/models/transaction_summary.dart';
import 'package:flutter/material.dart';

double getCategoryPerc(List<TransactionSummary> txSummary, index) {
  double totalAmount = 0.0;
  for (TransactionSummary summary in txSummary) {
    totalAmount += summary.amount != null ? summary.amount : 0;
  }
  double percentage =
      (txSummary[index].amount != null ? txSummary[index].amount : 0) *
          100 /
          totalAmount;
  return percentage != 0 ? double.parse(percentage.toStringAsFixed(1)) : 0.01;
}

List<Map<String, Object>> get transactionTypes {
  return [
    {'icon': Icons.restaurant_menu, 'title': 'Food', 'color': Colors.blueGrey},
    {'icon': Icons.shopping_cart, 'title': 'Groceries', 'color': Colors.cyan},
    {'icon': Icons.train, 'title': 'Travel', 'color': Colors.blue},
    {'icon': Icons.local_mall, 'title': 'Beauty', 'color': Colors.red},
    {'icon': Icons.theaters, 'title': 'Entertainment', 'color': Colors.green},
    {'icon': Icons.whatshot, 'title': 'Other', 'color': Colors.amber},
  ];
}
