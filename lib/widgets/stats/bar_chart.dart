import 'dart:async';
import 'package:expense_tracker/models/transaction_summary.dart';
import 'package:expense_tracker/uitls/tx_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SummaryBarChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SummaryBarChartState();

  final List<TransactionSummary> txSummary;

  SummaryBarChart(this.txSummary);
}

class SummaryBarChartState extends State<SummaryBarChart> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex;

  bool isPlaying = false;

  List<Map<String, Object>> _txTypes = transactionTypes;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: EdgeInsets.all(50.0),
        child: hasValidData()
            ? BarChart(
                mainBarData(widget.txSummary),
                swapAnimationDuration: animDuration,
              )
            : Container(
                child: Center(
                  child: Text(
                    'No Transaction found for this month',
                  ),
                ),
              ),
      ),
    );
  }

  bool hasValidData() {
    bool isValid = false;
    for (TransactionSummary summary in widget.txSummary) {
      if (summary.amount != null) {
        isValid = true;
        break;
      }
    }
    return isValid;
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [_txTypes[x]['color']],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 100,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(List<TransactionSummary> txSummary) =>
      List.generate(
        txSummary.length,
        (i) {
          return makeGroupData(
            i,
            getCategoryPerc(txSummary, i),
            isTouched: i == touchedIndex,
          );
        },
      );

  BarChartData mainBarData(List<TransactionSummary> txSummary) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String category = _txTypes[group.x.toInt()]['title'];
              return BarTooltipItem(
                category + '\n',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: txSummary[group.x].amount.toStringAsFixed(1),
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! PointerUpEvent &&
                barTouchResponse.touchInput is! PointerExitEvent) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: false,
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(txSummary),
      groupsSpace: 1,
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }
}
