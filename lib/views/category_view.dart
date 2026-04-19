import '../models/category_model.dart';
import '../models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/budget_provider.dart';
import '../../theme/app_theme.dart';
import '../utils/date_formatter.dart';
import '../widgets/transaction_card.dart';

class CategoryView extends StatelessWidget {
  final int categoryId;
  final int monthNumber;
  final int yearNumber;

  const CategoryView({
    super.key,
    required this.categoryId,
    required this.monthNumber,
    required this.yearNumber,
  });

  @override
  Widget build(BuildContext context) {
    final budgetProvider = context.watch<BudgetProvider>();

    final CategoryModel categoryData = budgetProvider.getCategory(
      yearNumber,
      monthNumber,
      categoryId,
    );

    final transactions = List<TransactionModel>.from(categoryData.transactions)
      ..sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: Text(DateUtilsHelper.getMonthName(monthNumber)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];

          return TransactionCard(
            amount: transaction.amount,
            note: transaction.note,
            date: transaction.date,
            repeatMonthly: transaction.repeatMonthly,
            onUpdate: (newAmount, newNote, newRepeatMonthly) {
              context.read<BudgetProvider>().updateTransaction(
                year: yearNumber,
                month: monthNumber,
                categoryId: categoryId,
                transactionId: transaction.id,
                newAmount: newAmount,
                newNote: newNote,
                newRepeatMonthly: newRepeatMonthly,
              );
            },
          );
        },
      ),
    );
  }
}
