import 'package:redux/redux.dart';
import 'package:meta/meta.dart';
import 'package:expense_tracker/database/database.dart';
import 'package:expense_tracker/redux/tx-summary/tx_summary_state.dart';
import '../store.dart';

@immutable
class SetTransactionSummaryStateAction {
  final TransactionSummaryState txSummaryState;

  SetTransactionSummaryStateAction(this.txSummaryState);
}

Future<void> fetchTxSummaryAction(DateTime monthDate) async {
  Store<AppState> store = Redux.store;
  store.dispatch(
    SetTransactionSummaryStateAction(
      TransactionSummaryState(isLoading: true),
    ),
  );

  try {
    final summaryData = await DBProvider.db.getMonthSummary(monthDate);
    store.dispatch(
      SetTransactionSummaryStateAction(
        TransactionSummaryState(
          isLoading: false,
          txSummary: summaryData,
        ),
      ),
    );
  } catch (error) {
    store.dispatch(
      SetTransactionSummaryStateAction(
        TransactionSummaryState(isLoading: false),
      ),
    );
  }
}
