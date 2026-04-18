import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class TransactionCard extends StatelessWidget {
  final double amount;
  final String? note;
  final DateTime date;
  final bool repeatMonthly;

  const TransactionCard({
    super.key,
    required this.amount,
    required this.note,
    required this.date,
    required this.repeatMonthly,
  });

  @override
  Widget build(BuildContext context) {
    final isNegative = amount < 0;

    return Container(
      height: 66,
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), //TOdo bnei allen card die hight gleich machen
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
      child: Row(
        children: [
          Icon(
            isNegative ? Icons.arrow_downward : Icons.arrow_upward,
            size: 18,
            color: isNegative ? Colors.red : AppTheme.primary, //todo berechnung??, bei eingabe bei transaktion wird immoment + als abbuchung genutzten, somit thoretisch falsch rum. In der app sollte das vorzeichen geswitched werden, aber in welchem schritt???
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              (note == null || note!.isEmpty) ? 'No title' : note!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${amount.toStringAsFixed(2)} €',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isNegative ? Colors.red : AppTheme.primary,
                ),
              ),
              Text(
                "${date.day}.${date.month}.${date.year}",
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
