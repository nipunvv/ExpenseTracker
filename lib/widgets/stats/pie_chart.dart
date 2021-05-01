import 'package:expense_tracker/models/transaction_summary.dart';
import 'package:expense_tracker/redux/store.dart';
import 'package:expense_tracker/redux/tx-summary/tx_summary_action.dart';
import 'package:expense_tracker/uitls/tx_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SummaryPieChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartState();
}

class PieChartState extends State {
  int touchedIndex;

  List<Map<String, Object>> txTypes = transactionTypes;

  @override
  void initState() {
    super.initState();
    Redux.store.dispatch(fetchTxSummaryAction);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: StoreConnector<AppState, List<TransactionSummary>>(
        distinct: true,
        converter: (store) => store.state.txSummaryState.txSummary,
        builder: (context, txSummary) {
          if (txSummary.length > 0) {
            return PieChart(
              PieChartData(
                pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                  setState(() {
                    final desiredTouch =
                        pieTouchResponse.touchInput is! PointerExitEvent &&
                            pieTouchResponse.touchInput is! PointerUpEvent;
                    if (desiredTouch &&
                        pieTouchResponse.touchedSection != null) {
                      touchedIndex =
                          pieTouchResponse.touchedSection.touchedSectionIndex;
                    } else {
                      touchedIndex = -1;
                    }
                  });
                }),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 60,
                sections: showingSections(getValidSummary(txSummary)),
              ),
            );
          }
          return Container(
            width: 0.0,
            height: 0.0,
          );
        },
      ),
    );
  }

  List<TransactionSummary> getValidSummary(List<TransactionSummary> txSummary) {
    List<TransactionSummary> summary = [];
    for (TransactionSummary tSummary in txSummary) {
      if (tSummary.amount != null) {
        summary.add(tSummary);
      }
    }
    return summary;
  }

  double getValue(double amount) {
    return amount != null ? double.parse(amount.toStringAsFixed(1)) : 1;
  }

  Color getColor(TransactionSummary summary) {
    Color areaColor = Colors.blue;
    String category = summary.category;
    txTypes.forEach((element) {
      areaColor = element['title'] == category ? element['color'] : areaColor;
    });
    return areaColor;
  }

  List<PieChartSectionData> showingSections(
      List<TransactionSummary> txSummary) {
    return List.generate(txSummary.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      return PieChartSectionData(
        color: getColor(txSummary[i]),
        value: getValue(txSummary[i].amount),
        title: '${getCategoryPerc(txSummary, i)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}
