import 'package:expense_tracker/constants/constants.dart';
import 'package:expense_tracker/widgets/reports.dart';
import 'package:expense_tracker/widgets/stats/stats.dart';
import 'package:flutter/material.dart';

void navigateToPage(int currentPage, int navigateTo, BuildContext context) {
  if (navigateTo == currentPage) {
    return;
  } else if (navigateTo == HOME_PAGE) {
    Navigator.popUntil(
      context,
      ModalRoute.withName('/'),
    );
  } else if (navigateTo == STATS_PAGE) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Stats(),
      ),
      ModalRoute.withName('/'),
    );
  } else if (navigateTo == REPORTS_PAGE) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Reports(),
      ),
      ModalRoute.withName('/'),
    );
  }
}
