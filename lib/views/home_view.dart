import 'package:buget_flow/models/category_model.dart';
import 'package:buget_flow/theme/app_theme.dart';
import 'package:buget_flow/views/settings/settings_view.dart';
import 'package:buget_flow/widgets/settings/budget_card.dart';
import 'package:flutter/material.dart';

import '../models/year_model.dart';
import '../widgets/dialogs/add_transaction_dialog.dart';
import '../widgets/title_card.dart';

class HomeView extends StatelessWidget {
  final String title;
  final List<YearModel> years;
  final List<CategoryModel> categories;

  HomeView({
    super.key,
    required this.title,
    required this.years,
    required this.categories,
  });

  final testCategories = [
    CategoryModel(
      id: 1,
      name: 'Lebensmittel',
      monthlyBudget: 400.0,
    ),
    CategoryModel(
      id: 2,
      name: 'Miete & Wohnen',
      monthlyBudget: 850.0,
    ),
    CategoryModel(
      id: 3,
      name: 'Freizeit & Hobby',
      monthlyBudget: 150.0,
    ),
  ];

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
          ...testCategories.map((category) {
            return BudgetCard(title: category.name, budget: category.monthlyBudget,);
          }).toList(),
          const TitleCard(title: 'Transactions'),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTransactionDialog(context, testCategories);
        },
        backgroundColor: AppTheme.primaryContainer,
        child: const Icon(Icons.add, color: AppTheme.textPrimary),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
