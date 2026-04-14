import 'package:buget_flow/models/settings_model.dart';

import '../models/transaction_model.dart';

void addTransaction({
  required double amount,
  required String note,
  required int categoryId,
  required int categoryVersion,
  required DateTime date,
  required bool repeatMonthly,
}) {

  final transaction = TransactionModel(
    amount: amount,
    note: note,
    categoryId: categoryId,
    categoryVersion: categoryVersion,
    date: date,
    repeatMonthly: repeatMonthly,
  );
}
