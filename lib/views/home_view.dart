import 'package:buget_flow/theme/app_theme.dart';
import 'package:buget_flow/views/settings/settings_view.dart';
import 'package:buget_flow/widgets/settings/budget_card.dart';
import 'package:flutter/material.dart';

import '../models/year_model.dart';
import '../widgets/dialogs/add_transaction_dialog.dart';
import '../widgets/title_card.dart';

class HomeView extends StatelessWidget{
  final String title;
  final List<YearModel> years;

  const HomeView({super.key, required this.title, required this.years});

  @override
  Widget build(BuildContext context) {
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
          TitleCard(title: "Buget Flow"),
          BudgetCard(title: "Budget", budget: 12),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {showAddTransactionDialog(context);},
        backgroundColor: AppTheme.primaryContainer,
        child: const Icon(Icons.add, color: AppTheme.textPrimary,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}