import 'dart:convert';
import 'dart:io';

import 'package:budget_flow/logic/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/category_model.dart';
import '../models/month_model.dart';
import '../models/transaction_model.dart';
import '../models/year_model.dart';

class BudgetProvider extends ChangeNotifier {
  List<YearModel> _years = [];
  bool _isLoading = true;
  SettingsProvider? _settingsProvider;

  List<YearModel> get years => _years;

  bool get isLoading => _isLoading;

  BudgetProvider() {
    loadData();
  }

  void updateSettings(SettingsProvider settings) {
    _settingsProvider = settings;
    notifyListeners();
  }

  //read json
  Future<void> loadData() async {
    try {
      final file = await _getFormattedFile();
      if (await file.exists()) {
        final String contents = await file.readAsString();
        final Map<String, dynamic> jsonData = jsonDecode(contents);

        if (jsonData.containsKey('years')) {
          _years = (jsonData['years'] as List)
              .map((y) => YearModel.fromJson(y))
              .toList();
        }
      }
    } catch (e) {
      debugPrint("Error loading data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //write json
  Future<void> saveData() async {
    try {
      final file = await _getFormattedFile();
      final Map<String, dynamic> dataToSave = {
        "years": _years.map((y) => y.toJson()).toList(),
      };
      await file.writeAsString(jsonEncode(dataToSave));
    } catch (e) {
      debugPrint("Error saving data: $e");
    }
  }

  void addTransaction(TransactionModel tx) {
    final int yKey = tx.date.year;
    final int mKey = tx.date.month;

    int yearIndex = _years.indexWhere((y) => y.year == yKey);
    if (yearIndex == -1) {
      _years.add(YearModel(year: yKey, months: {}));
      _years.sort((a, b) => a.year.compareTo(b.year));
      yearIndex = _years.indexWhere((y) => y.year == yKey);
    }

    final yearObj = _years[yearIndex];
    var monthObj = yearObj.months[mKey];

    if (monthObj == null) {
      monthObj = _generateMonthFromSettings(mKey);
      yearObj.months[mKey] = monthObj;
    }

    int catIndex = monthObj.categories.indexWhere((c) => c.id == tx.categoryId);

    CategoryModel? targetCategory;

    if (catIndex != -1) {
      targetCategory = monthObj.categories[catIndex];
    } else {
      final template = _settingsProvider?.settings?.categories.firstWhere(
        (c) => c.id == tx.categoryId,
      );

      if (template != null) {
        targetCategory = CategoryModel(
          id: template.id,
          name: template.name,
          monthlyBudget: template.monthlyBudget,
          spent: 0.0,
          transactions: [],
        );
        monthObj.categories.add(targetCategory);
        catIndex = monthObj.categories.length - 1;
      }
    }

    if (targetCategory == null) return;

    final newTransactions = [...targetCategory.transactions, tx];
    final newCatSpent = newTransactions.fold(0.0, (sum, t) => sum + t.amount);

    monthObj.categories[catIndex] = targetCategory.copyWith(
      transactions: newTransactions,
      spent: newCatSpent,
    );

    final newMonthSpent = monthObj.categories.fold(
      0.0,
      (sum, c) => sum + c.spent,
    );
    final newMonthBudget = monthObj.categories.fold(
      0.0,
      (sum, c) => sum + c.monthlyBudget,
    );

    yearObj.months[mKey] = monthObj.copyWith(
      spent: newMonthSpent,
      budget: newMonthBudget,
    );

    notifyListeners();
    saveData();
  }

  void updateTransaction({
    required int year,
    required int month,
    required int categoryId,
    required int transactionId,
    required double newAmount,
    required String newNote,
    required bool newRepeatMonthly,
  }) {
    int yearIndex = _years.indexWhere((y) => y.year == year);
    if (yearIndex == -1) return;
    final yearObj = _years[yearIndex];
    var monthObj = yearObj.months[month];
    if (monthObj == null) return;

    int catIndex = monthObj.categories.indexWhere((c) => c.id == categoryId);
    if (catIndex == -1) return;
    final category = monthObj.categories[catIndex];
    int txIndex = category.transactions.indexWhere(
      (t) => t.id == transactionId,
    );
    if (txIndex == -1) return;
    final updatedTransactions = List<TransactionModel>.from(
      category.transactions,
    );

    updatedTransactions[txIndex] = updatedTransactions[txIndex].copyWith(
      amount: newAmount,
      note: newNote,
      repeatMonthly: newRepeatMonthly,
    );
    final newCatSpent = updatedTransactions.fold(
      0.0,
      (sum, t) => sum + t.amount,
    );
    monthObj.categories[catIndex] = category.copyWith(
      transactions: updatedTransactions,
      spent: newCatSpent,
    );
    final newMonthSpent = monthObj.categories.fold(
      0.0,
      (sum, c) => sum + c.spent,
    );
    yearObj.months[month] = monthObj.copyWith(spent: newMonthSpent);
    notifyListeners();
    saveData();
  }

  void deleteTransaction({
    required int year,
    required int month,
    required int categoryId,
    required int transactionId,
  }) {
    int yearIndex = _years.indexWhere((y) => y.year == year);
    if (yearIndex == -1) return;

    final yearObj = _years[yearIndex];
    var monthObj = yearObj.months[month];
    if (monthObj == null) return;

    int catIndex = monthObj.categories.indexWhere((c) => c.id == categoryId);
    if (catIndex == -1) return;

    final category = monthObj.categories[catIndex];

    final updatedTransactions = List<TransactionModel>.from(category.transactions);
    updatedTransactions.removeWhere((t) => t.id == transactionId);

    final newCatSpent = updatedTransactions.fold(0.0, (sum, t) => sum + t.amount);

    monthObj.categories[catIndex] = category.copyWith(
      transactions: updatedTransactions,
      spent: newCatSpent,
    );

    final newMonthSpent = monthObj.categories.fold(0.0, (sum, c) => sum + c.spent);
    yearObj.months[month] = monthObj.copyWith(spent: newMonthSpent);

    notifyListeners();
    saveData();
  }

  MonthModel _generateMonthFromSettings(int monthNumber) {
    final settings = _settingsProvider?.settings;
    if (settings == null) return MonthModel.empty(monthNumber);

    final newCategories = settings.categories.map((template) {
      return CategoryModel(
        id: template.id,
        name: template.name,
        monthlyBudget: template.monthlyBudget,
        spent: 0.0,
        transactions: [],
      );
    }).toList();

    return MonthModel(
      month: monthNumber,
      income: settings.monthlyIncome,
      budget: newCategories.fold(0, (sum, c) => sum + c.monthlyBudget),
      spent: 0.0,
      categories: newCategories,
    );
  }

  Future<File> _getFormattedFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/budget_data.json');
  }

  YearModel getYear(int yearNumber) {
    return _years.firstWhere(
      (y) => y.year == yearNumber,
      orElse: () => YearModel(year: yearNumber, months: {}),
    );
  }

  MonthModel getMonth(int yearNumber, int monthNumber) {
    final year = getYear(yearNumber);
    return year.months[monthNumber] ?? MonthModel.empty(monthNumber);
  }

  CategoryModel getCategory(int yearNumber, int monthNumber, int categoryId) {
    final month = getMonth(yearNumber, monthNumber);
    return month.categories.firstWhere((c) => c.id == categoryId);
  }

  /*void showYear() {
    final yearNum = DateTime.now().year;
    int yearIndex = _years.indexWhere((y) => y.year == yearNum);
    final yearObj = _years[yearIndex];
    print(yearObj.toString());
  }*/
}
