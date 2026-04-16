import 'package:buget_flow/theme/app_theme.dart';
import 'package:buget_flow/views/settings/settings_view.dart';
import 'package:buget_flow/widgets/settings/budget_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/budget_provider.dart';
import '../logic/settings_provider.dart';
import '../widgets/dialogs/add_transaction_dialog.dart';

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
      body: years.isNotEmpty
          ? const Center(child: Text('No data available'))
          : ListView.builder(
              itemCount: years.length,
              itemBuilder: (context, index) {
                final year = years[index];

                double yearlySpend = 0;

                year.months.forEach((month, monthObj) {
                  yearlySpend += monthObj.spent;
                });

                return BudgetCard(
                  title: year.year.toString(),
                  budget: yearlySpend,
                  onUpdate: (String newTitle, double newBudget) {},
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
