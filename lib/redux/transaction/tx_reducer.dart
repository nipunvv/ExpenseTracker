import 'package:expense_tracker/redux/transaction/tx_action.dart';
import 'package:expense_tracker/redux/transaction/tx_state.dart';

transactionReducer(
    TransactionState prevState, SetTransactionStateAction action) {
  final payload = action.txState;
  return prevState.copyWith(
    isError: payload.isError,
    isLoading: payload.isLoading,
    transactions: payload.transactions,
  );
}
