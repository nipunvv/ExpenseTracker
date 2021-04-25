import 'package:intl/intl.dart';

String getMonthAndYear() {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('MMMM, yyyy');
  final String formatted = formatter.format(now);
  return formatted;
}
