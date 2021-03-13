import 'package:flutter/foundation.dart';

class TransactionSummary {
  final String category;
  final double amount;

  TransactionSummary({@required this.category, @required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'amount': amount,
    };
  }
}
