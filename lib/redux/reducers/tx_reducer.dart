import 'package:expense_tracker/redux/actions/tx_actions.dart';
import 'package:expense_tracker/redux/tx_state.dart';

transactionReducer(
    TransactionState prevState, SetTransactionStateAction action) {
  final payload = action.postsState;
  return prevState.copyWith(
    isError: payload.isError,
    isLoading: payload.isLoading,
    transactions: payload.transactions,
  );
}
