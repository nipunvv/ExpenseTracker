import 'package:expense_tracker/redux/tx-report/tx_report_action.dart';
import 'package:expense_tracker/redux/tx-report/tx_report_state.dart';

txReportReducer(
    TransactionReportState prevState, SetTransactionReportStateAction action) {
  final payload = action.txReportState;
  return prevState.copyWith(
    isError: payload.isError,
    isLoading: payload.isLoading,
    txReport: payload.txReport,
  );
}
