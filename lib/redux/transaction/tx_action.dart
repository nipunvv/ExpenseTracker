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

Future<void> fetchTransactionsAction(String category, DateTime date) async {
  Store<AppState> store = Redux.store;
  store.dispatch(
    SetTransactionStateAction(
      TransactionState(isLoading: true),
    ),
  );

  try {
    final transactions =
        await DBProvider.db.getSummaryByCategory(category, date);
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
  if (transaction.id == null) {
    await DBProvider.db.newTransaction(transaction);
  } else {
    await DBProvider.db.updateTransaction(transaction);
  }
  Redux.store
      .dispatch(fetchTransactionsAction(transaction.category, DateTime.now()));
  Redux.store.dispatch(fetchTxSummaryAction(DateTime.now()));
}

Future<void> deleteTransaction(Transaction transaction) async {
  await DBProvider.db.deleteTransaction(int.parse(transaction.id));
  Redux.store
      .dispatch(fetchTransactionsAction(transaction.category, DateTime.now()));
  Redux.store.dispatch(fetchTxSummaryAction(DateTime.now()));
}
