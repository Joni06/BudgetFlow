import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MonthCard extends StatelessWidget {
  final String monthName;
  final double spent;
  final double budget;
  final VoidCallback onTap;

  const MonthCard({
    super.key,
    required this.monthName,
    required this.spent,
    required this.budget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final bool overBudget = spent > budget && budget > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: overBudget ? Colors.red.withOpacity(0.3) : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  monthName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${spent.toStringAsFixed(2)} € / ${budget.toStringAsFixed(2)} €',
                  style: TextStyle(
                    color: overBudget ? Colors.red : AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppTheme.surfaceVariant,
                color: overBudget ? Colors.red : AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}