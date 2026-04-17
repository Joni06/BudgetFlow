import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../logic/budget_provider.dart';
import '../../logic/settings_provider.dart';
import '../../models/category_structure_model.dart';
import '../../models/transaction_model.dart';
import '../../theme/app_theme.dart';

void showAddTransactionDialog(BuildContext context) {
  showDialog(context: context, builder: (_) => AddTransactionDialog());
}

class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({super.key});

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final dateController = TextEditingController();
  CategoryStructureModel? selectedCategory;
  DateTime selectedDate = DateTime.now();
  bool isRepeatMonthly = false;

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProv = context.watch<SettingsProvider>();
    final categories = settingsProv.settings?.categories ?? [];
    return AlertDialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Add Transaction',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              amountController,
              'Enter amount',
              suffix: '€',
              numberOnly: true,
            ),
            const SizedBox(height: 12),

            _buildTextField(noteController, 'Enter note'),
            const SizedBox(height: 12),

            _buildDropdown(categories: categories),
            const SizedBox(height: 12),

            _buildDateField(dateController),
            const SizedBox(height: 12),

            _buildSwitch(),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
        TextButton(
          onPressed: _submit,
          child: Text(
            'Add',
            style: TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
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

  Widget _buildDropdown({required List<CategoryStructureModel> categories}) {
    return DropdownButtonFormField<CategoryStructureModel>(
      initialValue: selectedCategory,
      borderRadius: BorderRadius.circular(12),
      isExpanded: true,
      dropdownColor: AppTheme.surfaceVariant,
      decoration: InputDecoration(
        hintText: 'Select Category',
        filled: true,
        fillColor: AppTheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      ),
      items: categories.map((category) {
        return DropdownMenuItem(value: category, child: Text(category.name));
      }).toList(),
      onChanged: (value) => setState(() {
        selectedCategory = value;
      }),
    );
  }

  Widget _buildDateField(TextEditingController controller) {
    return TextField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        hintText: selectedDate.toString().split(' ')[0],
        filled: true,
        fillColor: AppTheme.surfaceVariant,
        suffixIcon: const Icon(
          Icons.calendar_today,
          color: AppTheme.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() => selectedDate = picked);
        }
      },
    );
  }

  Widget _buildSwitch() {
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
              value: isRepeatMonthly,
              onChanged: (value) => setState(() => isRepeatMonthly = value),
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

  void _submit() {
    final amountText = amountController.text.replaceAll(',', '.');
    final amount = double.tryParse(amountText);

    final note = noteController.text;
    final category = selectedCategory;
    final date = selectedDate;

    if (amount == null || category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an amount and select a category'),
        ),
      );
      return;
    }

    final newTransaction = TransactionModel(
      amount: amount,
      note: note,
      categoryId: category.id,
      date: date,
      repeatMonthly: isRepeatMonthly,
    );

    Provider.of<BudgetProvider>(
      context,
      listen: false,
    ).addTransaction(newTransaction);

    /*
    only for testing
    Provider.of<BudgetProvider>(
      context,
      listen: false,
    ).showYear();*/

    Navigator.pop(context);
  }
}
