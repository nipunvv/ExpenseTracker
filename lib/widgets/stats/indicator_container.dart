import 'package:expense_tracker/widgets/stats/indicator.dart';
import 'package:flutter/material.dart';

class IndicatorContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Indicator(
          color: Colors.blueGrey,
          text: 'Food',
          isSquare: true,
        ),
        SizedBox(
          height: 4,
        ),
        Indicator(
          color: Colors.cyan,
          text: 'Groceries',
          isSquare: true,
        ),
        SizedBox(
          height: 4,
        ),
        Indicator(
          color: Colors.blue,
          text: 'Travel',
          isSquare: true,
        ),
        SizedBox(
          height: 4,
        ),
        Indicator(
          color: Colors.red,
          text: 'Beauty',
          isSquare: true,
        ),
        SizedBox(
          height: 4,
        ),
        Indicator(
          color: Colors.green,
          text: 'Entertainment',
          isSquare: true,
        ),
        SizedBox(
          height: 4,
        ),
        Indicator(
          color: Colors.amber,
          text: 'Other',
          isSquare: true,
        ),
        SizedBox(
          height: 4,
        ),
      ],
    );
  }
}
