import 'package:redux/redux.dart';
import 'package:meta/meta.dart';
import 'package:expense_tracker/database/database.dart';
import 'package:expense_tracker/redux/tx-report/tx_report_state.dart';
import '../store.dart';

@immutable
class SetTransactionReportStateAction {
  final TransactionReportState txReportState;

  SetTransactionReportStateAction(this.txReportState);
}

Future<void> fetchTxReportAction(
    DateTime from, DateTime to, String category) async {
  Store<AppState> store = Redux.store;
  store.dispatch(
    SetTransactionReportStateAction(
      TransactionReportState(isLoading: true),
    ),
  );

  try {
    final reportData =
        await DBProvider.db.getTransactionReport(from, to, category);
    store.dispatch(
      SetTransactionReportStateAction(
        TransactionReportState(
          isLoading: false,
          txReport: reportData,
        ),
      ),
    );
  } catch (error) {
    store.dispatch(
      SetTransactionReportStateAction(
        TransactionReportState(isLoading: false),
      ),
    );
  }
}

Future<void> resetReport() async {
  Redux.store.dispatch(
    SetTransactionReportStateAction(
      TransactionReportState(
        isLoading: false,
        txReport: [],
      ),
    ),
  );
}
