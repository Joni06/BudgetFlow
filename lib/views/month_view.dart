import 'package:budget_flow/models/category_model.dart';
import 'package:budget_flow/models/month_model.dart';
import 'package:budget_flow/views/category_view.dart';
import 'package:budget_flow/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/budget_provider.dart';
import '../../theme/app_theme.dart';
import '../utils/date_formatter.dart';

class MonthView extends StatelessWidget {
  final int monthNumber;
  final int yearNumber;

  const MonthView({
    super.key,
    required this.monthNumber,
    required this.yearNumber,
  });

  @override
  Widget build(BuildContext context) {
    final budgetProvider = context.watch<BudgetProvider>();

    final MonthModel monthData = budgetProvider.getMonth(
      yearNumber,
      monthNumber,
    );

    final categories = List<CategoryModel>.from(monthData.categories)
      ..sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: Text(DateUtilsHelper.getMonthName(monthNumber)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return CategoryCard(
            categoryName: category.name,
            spent: category.spent,
            budget: category.monthlyBudget,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryView(
                    monthNumber: monthNumber,
                    yearNumber: yearNumber,
                    categoryId: category.id,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
