import 'package:expense_tracker/database/database.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/redux/store.dart';
import 'package:expense_tracker/redux/transaction/tx_state.dart';
import 'package:expense_tracker/redux/tx-summary/tx_summary_action.dart';
import 'package:redux/redux.dart';
import 'package:meta/meta.dart';

@immutable
class SetTransactionStateAction {
  final TransactionState txState;

  SetTransactionStateAction(this.txState);
}

Future<void> fetchTransactionsAction(
    Store<AppState> store, String category) async {
  store.dispatch(
    SetTransactionStateAction(
      TransactionState(isLoading: true),
    ),
  );

  try {
    final transactions = category != null
        ? await DBProvider.db.getSummaryByCategory(category)
        : await DBProvider.db.getTransactions();
    store.dispatch(
      SetTransactionStateAction(
        TransactionState(
          isLoading: false,
          transactions: transactions,
        ),
      ),
    );
  } catch (error) {
    store.dispatch(
      SetTransactionStateAction(
        TransactionState(isLoading: false),
      ),
    );
  }
}

Future<void> createTransaction(Transaction transaction) async {
  await DBProvider.db.newTransaction(transaction);
  Redux.store.dispatch(fetchTxSummaryAction);
}
