import 'package:meta/meta.dart';
import 'package:expense_tracker/models/transaction.dart';

@immutable
class TransactionReportState {
  final bool isError;
  final bool isLoading;
  final List<Transaction> txReport;

  TransactionReportState({
    this.isError,
    this.isLoading,
    this.txReport,
  });

  factory TransactionReportState.initial() => TransactionReportState(
        isLoading: false,
        isError: false,
        txReport: const [],
      );

  TransactionReportState copyWith({
    @required bool isError,
    @required bool isLoading,
    @required List<Transaction> txReport,
  }) {
    return TransactionReportState(
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      txReport: txReport ?? this.txReport,
    );
  }
}
