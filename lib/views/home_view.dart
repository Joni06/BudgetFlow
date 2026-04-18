import 'package:budget_flow/theme/app_theme.dart';
import 'package:budget_flow/views/settings/settings_view.dart';
import 'package:budget_flow/views/year_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/budget_provider.dart';
import '../logic/settings_provider.dart';
import '../widgets/dialogs/add_transaction_dialog.dart';
import '../widgets/year_card.dart';

class HomeView extends StatelessWidget {
  final String title;

  const HomeView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final budgetProv = context.watch<BudgetProvider>();
    final settingsProv = context.watch<SettingsProvider>();

    if (budgetProv.isLoading || settingsProv.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final years = budgetProv.years;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsView(title: 'Settings'),
                ),
              );
            },
          ),
        ],
      ),
      body: years.isEmpty
          ? const Center(child: Text('No data available'))
          : ListView.builder(
              itemCount: years.length,
              itemBuilder: (context, index) {
                final yearObj = years[index];
                final totalYearlySpent = yearObj.months.values.fold(
                  0.0,
                  (sum, m) => sum + m.spent,
                );

                return YearCard(
                  year: yearObj.year,
                  spent: totalYearlySpent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            YearView(yearNumber: yearObj.year),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTransactionDialog(context);
        },
        backgroundColor: AppTheme.primaryContainer,
        child: const Icon(Icons.add, color: AppTheme.textPrimary),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }
}
