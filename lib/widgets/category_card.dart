import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final double spent;
  final double budget;
  final VoidCallback onTap;
  final Function (double newBudget) onUpdate;
  final VoidCallback onDelete;

  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.spent,
    required this.budget,
    required this.onTap,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final progress = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final overBudget = spent > budget && budget > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 66),
        margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${spent.toStringAsFixed(2)} / ${budget.toStringAsFixed(
                            2)} €',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: overBudget
                              ? Colors.red
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: AppTheme.surfaceVariant,
                      color: overBudget ? Colors.red : AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(Icons.edit, size: 20, color: AppTheme.primary),
              onPressed: () {
                _showEditDialog(context);
              },
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(Icons.delete, size: 20, color: AppTheme.primary),
              onPressed: () {_showDeleteConfirmation(context);},
            ),
          ],
        ),
      ),
    );
  }

  _showEditDialog(BuildContext context) {
    final budgetController = TextEditingController(text: budget.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Edit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(
                      budgetController,
                      "New budget",
                      suffix: "€",
                      numberOnly: true,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final newAmount =
                        double.tryParse(
                          budgetController.text.replaceFirst(',', '.'),
                        ) ??
                            budget;
                    onUpdate(newAmount);
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete?"),
        content: const Text("Are you sure you want to delete this category, all data in this category for this month is lost?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller,
      String hint, {
        String? suffix,
        bool numberOnly = false,
      }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: AppTheme.textPrimary),
      inputFormatters: numberOnly
          ? [FilteringTextInputFormatter.allow(RegExp(r'^[-]?\d*[,.]?\d{0,2}'))]
          : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppTheme.textSecondary),
        suffixText: suffix,
        filled: true,
        fillColor: AppTheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
