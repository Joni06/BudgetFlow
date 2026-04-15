import 'dart:convert';
import 'dart:io';
import 'package:buget_flow/logic/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/category_model.dart';
import '../models/year_model.dart';
import '../models/transaction_model.dart';
import '../models/month_model.dart';

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

    final catIndex = monthObj.categories.indexWhere((c) => c.id == tx.categoryId);

    if (catIndex != -1) {
      final oldCategory = monthObj.categories[catIndex];
      final newTransactions = [...oldCategory.transactions, tx];
      final newSpent = newTransactions.fold(0.0, (sum, t) => sum + t.amount);

      monthObj.categories[catIndex] = oldCategory.copyWith(
        transactions: newTransactions,
        spent: newSpent,
      );
    }
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
}