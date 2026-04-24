import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../logic/settings_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/settings/budget_card.dart';

class SettingsView extends StatelessWidget {
  final String title;

  const SettingsView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final settingsProv = context.watch<SettingsProvider>();
    final categories = settingsProv.settings?.categories ?? [];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: Text(title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),
          BudgetCard(
            title: "Monthly Income",
            budget: settingsProv.settings?.monthlyIncome ?? 0.0,
            color: AppTheme.surface,
            monthlyIncome: false,
            shadow: true,
            onUpdate: (newTitle, newIncome) {
              context.read<SettingsProvider>().updateIncome(newIncome);
            },
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                title: Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                iconColor: AppTheme.primary,
                collapsedIconColor: AppTheme.textSecondary,
                children: [
                  ...categories.map(
                    (cat) => BudgetCard(
                      title: cat.name,
                      budget: cat.monthlyBudget,
                      color: AppTheme.surfaceVariant,
                      shadow: false,
                      onUpdate: (newTitle, newBudget) {
                        context.read<SettingsProvider>().updateCategory(
                          cat,
                          newTitle,
                          newBudget,
                        );
                      },
                      onDelete: () => settingsProv.removeCategory(cat),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () => _showAddCategoryDialog(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: AppTheme.primary),
                            const SizedBox(width: 5),
                            Text(
                              "Add Category",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    final budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "New Category",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: "Category Name",
                hintStyle: TextStyle(color: AppTheme.textSecondary),
                filled: true,
                fillColor: AppTheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: budgetController,
              style: TextStyle(color: AppTheme.textPrimary),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^[+-]?\d*[,.]?\d{0,2}'),
                ),
              ],
              decoration: InputDecoration(
                hintText: "Default Budget",
                hintStyle: TextStyle(color: AppTheme.textSecondary),
                suffixText: "€",
                filled: true,
                fillColor: AppTheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text;
              final budget = double.tryParse(budgetController.text) ?? 0.0;

              if (name.isNotEmpty) {
                Provider.of<SettingsProvider>(
                  context,
                  listen: false,
                ).addCategoryTemplate(name, budget);
                Navigator.pop(context);
              }
            },
            child: Text("Add", style: TextStyle(color: AppTheme.primary)),
          ),
        ],
      ),
    );
  }
}
