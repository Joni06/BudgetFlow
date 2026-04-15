import '../models/transaction_model.dart';

void addTransaction({
  required double amount,
  required String note,
  required int categoryId,
  required DateTime date,
  required bool repeatMonthly,
}) {

  final transaction = TransactionModel(
    amount: amount,
    note: note,
    categoryId: categoryId,
    date: date,
    repeatMonthly: repeatMonthly,
  );
}
