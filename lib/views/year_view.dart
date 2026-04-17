import 'package:flutter/material.dart';
import '../../models/year_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/month_card.dart';

class YearView extends StatelessWidget {
  final YearModel yearData;

  const YearView({super.key, required this.yearData});

  @override
  Widget build(BuildContext context) {
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
            monthName: _getMonthName(monthKey),
            spent: month.spent,
            budget: month.budget,
            onTap: () {
              //TODO
            },
          );
        },
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'Mai', 'June',
      'Juli', 'August', 'September', 'October', 'November', 'December'
    ];
    return (month >= 1 && month <= 12) ? monthNames[month - 1] : 'Unknown';
  }
}