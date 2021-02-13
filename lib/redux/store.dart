import 'package:expense_tracker/redux/actions/tx_actions.dart';
import 'package:expense_tracker/redux/reducers/tx_reducer.dart';
import 'package:expense_tracker/redux/tx_state.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SetTransactionStateAction) {
    final nextPostsState = transactionReducer(state.postsState, action);

    return state.copyWith(postsState: nextPostsState);
  }

  return state;
}

@immutable
class AppState {
  final TransactionState postsState;

  AppState({
    @required this.postsState,
  });

  AppState copyWith({
    TransactionState postsState,
  }) {
    return AppState(
      postsState: postsState ?? this.postsState,
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
    final postsStateInitial = TransactionState.initial();

    _store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState(postsState: postsStateInitial),
    );
  }
}
