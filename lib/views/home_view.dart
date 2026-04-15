import 'package:buget_flow/theme/app_theme.dart';
import 'package:buget_flow/views/settings/settings_view.dart';
import 'package:buget_flow/widgets/settings/budget_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/budget_provider.dart';
import '../logic/settings_provider.dart';
import '../widgets/dialogs/add_transaction_dialog.dart';
import '../widgets/title_card.dart';

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

    final categories = settingsProv.settings?.categories ?? [];

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
      body: ListView(
        children: [
          ...categories.map((category) {
            return BudgetCard(
              title: category.name,
              budget: category.monthlyBudget,
            );
          }),
          const TitleCard(title: 'Transactions'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTransactionDialog(context, categories);
        },
        backgroundColor: AppTheme.primaryContainer,
        child: const Icon(Icons.add, color: AppTheme.textPrimary),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }
}
