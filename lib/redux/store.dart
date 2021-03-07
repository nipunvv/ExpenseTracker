import 'package:expense_tracker/redux/actions/tx_actions.dart';
import 'package:expense_tracker/redux/reducers/tx_reducer.dart';
import 'package:expense_tracker/redux/tx_state.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SetTransactionStateAction) {
    final nextTxState = transactionReducer(state.txState, action);

    return state.copyWith(txState: nextTxState);
  }

  return state;
}

@immutable
class AppState {
  final TransactionState txState;

  AppState({
    @required this.txState,
  });

  AppState copyWith({
    TransactionState txState,
  }) {
    return AppState(
      txState: txState ?? this.txState,
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
    final txStateInitial = TransactionState.initial();

    _store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState(txState: txStateInitial),
    );
  }
}
