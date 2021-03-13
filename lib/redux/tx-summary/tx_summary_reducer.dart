import 'package:expense_tracker/redux/tx-summary/tx_summary_action.dart';
import 'package:expense_tracker/redux/tx-summary/tx_summary_state.dart';

txSummaryReducer(TransactionSummaryState prevState,
    SetTransactionSummaryStateAction action) {
  final payload = action.txSummaryState;
  return prevState.copyWith(
    isError: payload.isError,
    isLoading: payload.isLoading,
    txSummary: payload.txSummary,
  );
}
