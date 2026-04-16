import 'package:buget_flow/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BudgetCard extends StatelessWidget {
  final String title;
  final double budget;
  final Color? color;
  final bool shadow;

  final Function(String newTitle, double newBudget) onUpdate;

  const BudgetCard({
    super.key,
    required this.title,
    required this.budget,
    this.color,
    this.shadow = true,
    required this.onUpdate,
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                //TODO
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color ?? AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (shadow)
            BoxShadow(
              color: Colors.black.withValues(),
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${budget.toStringAsFixed(2)} €',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 4),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(Icons.edit, size: 20, color: AppTheme.primary),
                onPressed: () {
                  _showEditDialog(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
