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
    final progress = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final overBudget = spent > budget && budget > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  monthName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${spent.toStringAsFixed(2)} €',
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
                color: overBudget
                    ? Colors.red
                    : AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}