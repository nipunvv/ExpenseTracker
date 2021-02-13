import 'dart:convert';

import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/redux/store.dart';
import 'package:expense_tracker/redux/tx_state.dart';
import 'package:redux/redux.dart';
import 'package:meta/meta.dart';

@immutable
class SetTransactionStateAction {
  final TransactionState postsState;

  SetTransactionStateAction(this.postsState);
}

Future<void> fetchPostsAction(Store<AppState> store) async {
  store.dispatch(SetTransactionStateAction(TransactionState(isLoading: true)));

  try {
    // final response = await http.get('https://jsonplaceholder.typicode.com/posts');
    final response = null;
    assert(response.statusCode == 200);
    final jsonData = json.decode(response.body);
    store.dispatch(
      SetTransactionStateAction(
        TransactionState(
          isLoading: false,
          transactions: [],
        ),
      ),
    );
  } catch (error) {
    store.dispatch(
        SetTransactionStateAction(TransactionState(isLoading: false)));
  }
}
