import 'package:buget_flow/models/category_model.dart';
import 'package:flutter/material.dart';

import '../../logic/search_newest_version.dart';
import '../../models/transaction_model.dart';
import '../../theme/app_theme.dart';

void showAddTransactionDialog(
  BuildContext context,
  List<CategoryModel> categories,
) {
  showDialog(
    context: context,
    builder: (_) => AddTransactionDialog(categories: categories),
  );
}

class AddTransactionDialog extends StatefulWidget {
  final List<CategoryModel> categories;

  const AddTransactionDialog({super.key, required this.categories});

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final amountController = TextEditingController(text: '-');
  final noteController = TextEditingController();
  CategoryModel? selectedCategory;
  DateTime selectedDate = DateTime.now();
  bool isRepeatMonthly = false;

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add Transaction',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(amountController, 'Enter amount', suffix: '€'),
            const SizedBox(height: 12),

            _buildTextField(noteController, 'Enter note'),
            const SizedBox(height: 12),

            _buildDropdown(),
            const SizedBox(height: 12),

            _buildDateField(),
            const SizedBox(height: 12),

            SwitchListTile(
              value: isRepeatMonthly,
              onChanged: (value) => setState(() => isRepeatMonthly = value),
              title: const Text('Repeat Monthly'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: _submit, child: const Text('OK')),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    String? suffix,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
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

  Widget _buildDropdown() {
    return DropdownButtonFormField<CategoryModel>(
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
      ),
      items: widget.categories.map((category) {
        return DropdownMenuItem(value: category, child: Text(category.name));
      }).toList(),
      onChanged: (value) => setState(() {
        selectedCategory = value;
      }),
    );
  }

  Widget _buildDateField() {
    return TextField(
      readOnly: true,
      controller: TextEditingController(
        text: selectedDate.toString().split(' ')[0],
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppTheme.surfaceVariant,
        suffixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (picked != null) {
          setState(() => selectedDate = picked);
        }
      },
    );
  }

  void _submit() {
    final amount = double.tryParse(amountController.text);
    if (amount == null || selectedCategory == null) {
      //TODO add null check also for selectedCategory
      return;
    }
    final int categoryVersion = searchNewestVersion(
      categoryId: selectedCategory!.id,
      categories: widget.categories,
    );

    TransactionModel transaction = TransactionModel(
      amount: amount,
      note: noteController.text,
      categoryId: selectedCategory!.id,
      categoryVersion: categoryVersion,
      date: selectedDate,
      repeatMonthly: isRepeatMonthly,
    );

    Navigator.pop(context);
  }
}
