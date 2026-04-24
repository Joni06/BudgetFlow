import 'dart:convert';
import 'dart:io';

import 'package:budget_flow/logic/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart'; // Für firstWhereOrNull

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

  YearModel _getOrAddYear(int year) {
    var yearObj = _years.firstWhereOrNull((y) => y.year == year);
    if (yearObj == null) {
      yearObj = YearModel(year: year, months: {});
      _years.add(yearObj);
      _years.sort((a, b) => a.year.compareTo(b.year));
    }
    return yearObj;
  }

  void _updateMonthData(YearModel yearObj, int monthKey, MonthModel monthObj) {
    final totalSpent = monthObj.categories.fold(0.0, (sum, c) => sum + c.spent);
    final totalBudget = monthObj.categories.fold(
      0.0,
      (sum, c) => sum + c.monthlyBudget,
    );

    yearObj.months[monthKey] = monthObj.copyWith(
      spent: totalSpent,
      budget: totalBudget,
    );

    notifyListeners();
    saveData();
  }

  void addTransaction(TransactionModel tx) {
    final yearObj = _getOrAddYear(tx.date.year);
    final mKey = tx.date.month;
    var monthObj = yearObj.months[mKey] ?? _generateMonthFromSettings(mKey);

    int catIndex = monthObj.categories.indexWhere((c) => c.id == tx.categoryId);

    if (catIndex == -1) {
      final template = _settingsProvider?.settings?.categories.firstWhereOrNull(
        (c) => c.id == tx.categoryId,
      );
      if (template == null) return;

      monthObj.categories.add(
        CategoryModel(
          id: template.id,
          name: template.name,
          monthlyBudget: template.monthlyBudget,
          spent: 0.0,
          transactions: [],
        ),
      );
      catIndex = monthObj.categories.length - 1;
    }

    final category = monthObj.categories[catIndex];
    final updatedTxs = [...category.transactions, tx];

    monthObj.categories[catIndex] = category.copyWith(
      transactions: updatedTxs,
      spent: updatedTxs.fold(0.0, (sum, t) => sum! + t.amount),
    );

    _updateMonthData(yearObj, mKey, monthObj);
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
    final yearObj = _getOrAddYear(year);
    var monthObj = yearObj.months[month] ?? _generateMonthFromSettings(month);

    final catIndex = monthObj.categories.indexWhere((c) => c.id == categoryId);
    if (catIndex == -1) return;

    final category = monthObj.categories[catIndex];
    final txIndex = category.transactions.indexWhere(
      (t) => t.id == transactionId,
    );
    if (txIndex == -1) return;

    final updatedTxs = List<TransactionModel>.from(category.transactions);
    updatedTxs[txIndex] = updatedTxs[txIndex].copyWith(
      amount: newAmount,
      note: newNote,
      repeatMonthly: newRepeatMonthly,
    );

    monthObj.categories[catIndex] = category.copyWith(
      transactions: updatedTxs,
      spent: updatedTxs.fold(0.0, (sum, t) => sum! + t.amount),
    );

    _updateMonthData(yearObj, month, monthObj);
  }

  void deleteTransaction({
    required int year,
    required int month,
    required int categoryId,
    required int transactionId,
  }) {
    final yearObj = _getOrAddYear(year);
    var monthObj = yearObj.months[month] ?? _generateMonthFromSettings(month);

    final catIndex = monthObj.categories.indexWhere((c) => c.id == categoryId);
    if (catIndex == -1) return;

    final category = monthObj.categories[catIndex];
    final updatedTxs = category.transactions
        .where((t) => t.id != transactionId)
        .toList();

    monthObj.categories[catIndex] = category.copyWith(
      transactions: updatedTxs,
      spent: updatedTxs.fold(0.0, (sum, t) => sum! + t.amount),
    );

    _updateMonthData(yearObj, month, monthObj);
  }

  void updateCategory({
    required int year,
    required int month,
    required int categoryId,
    required double newBudget,
  }) {
    final yearObj = _getOrAddYear(year);
    var monthObj = yearObj.months[month] ?? _generateMonthFromSettings(month);

    final catIndex = monthObj.categories.indexWhere((c) => c.id == categoryId);
    if (catIndex == -1) return;

    monthObj.categories[catIndex] = monthObj.categories[catIndex].copyWith(
      monthlyBudget: newBudget,
    );

    _updateMonthData(yearObj, month, monthObj);
  }

  void deleteCategory({
    required int year,
    required int month,
    required int categoryId,
  }) {
    final yearObj = _getOrAddYear(year);
    var monthObj = yearObj.months[month] ?? _generateMonthFromSettings(month);

    monthObj.categories.removeWhere((c) => c.id == categoryId);

    _updateMonthData(yearObj, month, monthObj);
  }

  void updateMonthIncome({
    required int year,
    required int month,
    required double newIncome,
  }) {
    final yearObj = _years.firstWhereOrNull((y) => y.year == year);
    final monthObj = yearObj?.months[month];

    yearObj?.months[month] = monthObj!.copyWith(income: newIncome);
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
      budget: newCategories.fold(0.0, (sum, c) => sum + c.monthlyBudget),
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
    return year.months[monthNumber] ?? _generateMonthFromSettings(monthNumber);
  }

  CategoryModel getCategory(int yearNumber, int monthNumber, int categoryId) {
    final month = getMonth(yearNumber, monthNumber);
    return month.categories.firstWhere((c) => c.id == categoryId);
  }
}