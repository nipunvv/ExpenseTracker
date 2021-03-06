import 'package:expense_tracker/redux/transaction/tx_action.dart';
import 'package:expense_tracker/redux/transaction/tx_reducer.dart';
import 'package:expense_tracker/redux/transaction/tx_state.dart';
import 'package:expense_tracker/redux/tx-report/tx_report_action.dart';
import 'package:expense_tracker/redux/tx-report/tx_report_reducer.dart';
import 'package:expense_tracker/redux/tx-report/tx_report_state.dart';
import 'package:expense_tracker/redux/tx-summary/tx_summary_action.dart';
import 'package:expense_tracker/redux/tx-summary/tx_summary_reducer.dart';
import 'package:expense_tracker/redux/tx-summary/tx_summary_state.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SetTransactionSummaryStateAction) {
    final nextTxSummaryState = txSummaryReducer(state.txSummaryState, action);

    return state.copyWith(txSummaryState: nextTxSummaryState);
  } else if (action is SetTransactionStateAction) {
    final nextTxState = transactionReducer(state.txState, action);

    return state.copyWith(txState: nextTxState);
  } else if (action is SetTransactionReportStateAction) {
    final nextTxReportState = txReportReducer(state.txReportState, action);
    return state.copyWith(txReportState: nextTxReportState);
  }

  return state;
}

@immutable
class AppState {
  final TransactionSummaryState txSummaryState;
  final TransactionState txState;
  final TransactionReportState txReportState;

  AppState({
    @required this.txSummaryState,
    @required this.txState,
    @required this.txReportState,
  });

  AppState copyWith({
    TransactionSummaryState txSummaryState,
    TransactionState txState,
    TransactionReportState txReportState,
  }) {
    return AppState(
      txSummaryState: txSummaryState ?? this.txSummaryState,
      txState: txState ?? this.txState,
      txReportState: txReportState ?? this.txReportState,
    );
  }
}

class Redux {
  static Store<AppState> _store;

  static Store<AppState> get store {
    if (_store == null) {
      throw Exception("store is not initialized");
    } else {
      return _store;
    }
  }

  static Future<void> init() async {
    final txSummaryStateInitial = TransactionSummaryState.initial();
    final txStateInitial = TransactionState.initial();
    final txReportStateInitial = TransactionReportState.initial();

    _store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState(
        txSummaryState: txSummaryStateInitial,
        txState: txStateInitial,
        txReportState: txReportStateInitial,
      ),
    );
  }
}
