import 'package:expense_tracker/widgets/stats/indicator.dart';
import 'package:flutter/material.dart';

class IndicatorContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              Column(
                children: [
                  Indicator(
                    color: Colors.blueGrey,
                    text: 'Food',
                    isSquare: true,
                  ),
                ],
              ),
              Column(
                children: [
                  Indicator(
                    color: Colors.cyan,
                    text: 'Groceries',
                    isSquare: true,
                  ),
                ],
              ),
            ],
          ),
          TableRow(
            children: [
              Column(
                children: [
                  Indicator(
                    color: Colors.blue,
                    text: 'Travel',
                    isSquare: true,
                  ),
                ],
              ),
              Column(
                children: [
                  Indicator(
                    color: Colors.red,
                    text: 'Beauty',
                    isSquare: true,
                  ),
                ],
              ),
            ],
          ),
          TableRow(
            children: [
              Column(
                children: [
                  Indicator(
                    color: Colors.green,
                    text: 'Entertainment',
                    isSquare: true,
                  ),
                ],
              ),
              Column(
                children: [
                  Indicator(
                    color: Colors.amber,
                    text: 'Other',
                    isSquare: true,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
