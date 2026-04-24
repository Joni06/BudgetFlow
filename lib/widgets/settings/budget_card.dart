import 'dart:ui';

import 'package:budget_flow/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BudgetCard extends StatelessWidget {
  final String title;
  final double budget;
  final Color? color;
  final bool shadow;
  final bool monthlyIncome;

  final Function(String newTitle, double newBudget) onUpdate;
  final VoidCallback? onDelete;

  const BudgetCard({
    super.key,
    required this.title,
    required this.budget,
    this.color,
    this.shadow = true,
    this.monthlyIncome = true,
    required this.onUpdate,
    this.onDelete,
  });

  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: title);
    final budgetController = TextEditingController(text: budget.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (monthlyIncome) ...[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'New Title',
                    hintStyle: TextStyle(color: AppTheme.textSecondary),
                    filled: true,
                    fillColor: AppTheme.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 12),
              ],
              TextField(
                controller: budgetController,
                style: TextStyle(color: AppTheme.textPrimary),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^[+-]?\d*[,.]?\d{0,2}'),
                  ),
                ],
                decoration: InputDecoration(
                  hintText: "New Budget",
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
              Text('\n\nThis wont apply for this or past months',style: TextStyle(color: Colors.red),),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newTitle = titleController.text;
                final newBudget =
                    double.tryParse(budgetController.text) ?? budget;

                onUpdate(newTitle, newBudget);

                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: Column(
            mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to delete "$title"?'),
              Text('\n\nThis wont apply for this or past months',style: TextStyle(color: Colors.red),),
            ]
          ),
          backgroundColor: AppTheme.surface,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onDelete?.call();
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: color ?? AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (shadow)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${budget.toStringAsFixed(2)} €',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(Icons.edit, size: 20, color: AppTheme.primary),
                onPressed: () {
                  _showEditDialog(context);
                },
              ),
              if (!shadow)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.delete, size: 20, color: AppTheme.primary),
                  onPressed: () {
                    _showDeleteDialog(context);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
