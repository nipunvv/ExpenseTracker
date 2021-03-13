import 'package:meta/meta.dart';
import 'package:expense_tracker/models/transaction_summary.dart';

@immutable
class TransactionSummaryState {
  final bool isError;
  final bool isLoading;
  final List<TransactionSummary> txSummary;

  TransactionSummaryState({
    this.isError,
    this.isLoading,
    this.txSummary,
  });

  factory TransactionSummaryState.initial() => TransactionSummaryState(
        isLoading: false,
        isError: false,
        txSummary: const [],
      );

  TransactionSummaryState copyWith({
    @required bool isError,
    @required bool isLoading,
    @required List<TransactionSummary> txSummary,
  }) {
    return TransactionSummaryState(
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      txSummary: txSummary ?? this.txSummary,
    );
  }
}
