import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

class TransactionCard extends StatelessWidget {
  final double amount;
  final String? note;
  final DateTime date;
  final bool repeatMonthly;

  final Function(double newAmount, String newNote, bool newRepeatMonthly)
  onUpdate;
  final VoidCallback onDelete;

  const TransactionCard({
    super.key,
    required this.amount,
    required this.note,
    required this.date,
    required this.repeatMonthly,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    var negativeAmount = amount * (-1);
    final isNegative = negativeAmount < 0;

    return Container(
      height: 66,
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
          Icon(
            isNegative ? Icons.arrow_downward : Icons.arrow_upward,
            size: 18,
            color: isNegative ? Colors.red : AppTheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              (note == null || note!.isEmpty) ? 'No title' : note!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${negativeAmount.toStringAsFixed(2)} €',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isNegative ? Colors.red : AppTheme.primary,
                ),
              ),
              Text(
                "${date.day}.${date.month}.${date.year}",
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(width: 10),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(Icons.edit, size: 20, color: AppTheme.primary),
            onPressed: () {
              _showEditDialog(context);
            },
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(Icons.delete, size: 20, color: AppTheme.primary),
            onPressed: () {
              _deleteTransaction(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
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

  Widget _buildSwitch(bool currentValue, Function(bool) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(16, 3, 6, 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Repeat Monthly',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: currentValue,
              onChanged: onChanged,
              activeThumbColor: AppTheme.primary,
              inactiveThumbColor: AppTheme.textSecondary,
              inactiveTrackColor: AppTheme.surfaceVariant,
              trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
                states,
              ) {
                if (!states.contains(WidgetState.selected)) {
                  return AppTheme.textSecondary;
                }
                return AppTheme.primary;
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final amountController = TextEditingController(text: amount.toString());
    final noteController = TextEditingController(text: note);
    bool isRepeatMonthly = repeatMonthly;

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
                      amountController,
                      "New amount",
                      suffix: "€",
                      numberOnly: true,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(noteController, "New note"),
                    const SizedBox(height: 12),
                    _buildSwitch(isRepeatMonthly, (val) {
                      setDialogState(() => isRepeatMonthly = val);
                    }),
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
                          amountController.text.replaceFirst(',', '.'),
                        ) ??
                        amount;
                    onUpdate(newAmount, noteController.text, isRepeatMonthly);
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

  void _deleteTransaction(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text("Are you sure you want to delete this transaction?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onDelete();
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
