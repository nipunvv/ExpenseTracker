import 'package:expense_tracker/models/transaction.dart';
import 'package:meta/meta.dart';

@immutable
class TransactionState {
  final bool isError;
  final bool isLoading;
  final List<Transaction> transactions;

  TransactionState({
    this.isError,
    this.isLoading,
    this.transactions,
  });

  factory TransactionState.initial() => TransactionState(
        isLoading: false,
        isError: false,
        transactions: const [],
      );

  TransactionState copyWith({
    @required bool isError,
    @required bool isLoading,
    @required List<Transaction> transactions,
  }) {
    return TransactionState(
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      transactions: transactions ?? this.transactions,
    );
  }
}
