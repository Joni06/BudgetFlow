import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/budget_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/month_card.dart';
import '../utils/date_formatter.dart';
import 'month_view.dart';

class YearView extends StatelessWidget {
  final int yearNumber;

  const YearView({super.key, required this.yearNumber});

  @override
  Widget build(BuildContext context) {
    final budgetProvider = context.watch<BudgetProvider>();

    final yearData = budgetProvider.getYear(yearNumber);

    final sortedMonthKeys = yearData.months.keys.toList()..sort();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: Text('${yearData.year}'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: sortedMonthKeys.length,
        itemBuilder: (context, index) {
          final monthKey = sortedMonthKeys[index];
          final month = yearData.months[monthKey]!;

          return MonthCard(
            monthName: DateUtilsHelper.getMonthName(monthKey),
            spent: month.spent,
            budget: month.budget,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MonthView(yearNumber: yearNumber, monthNumber: monthKey),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
