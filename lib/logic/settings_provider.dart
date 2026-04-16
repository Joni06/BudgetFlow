import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/category_structure_model.dart';
import '../models/settings_model.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsModel? _settings;
  bool _isLoading = true;

  SettingsModel? get settings => _settings;
  bool get isLoading => _isLoading;

  SettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final Map<String, dynamic> json = jsonDecode(contents);
        if (json['settings'] != null && (json['settings'] as List).isNotEmpty) {
          _settings = SettingsModel.fromJson(json['settings'][0]);
        }
      }

      _settings ??= SettingsModel(monthlyIncome: 0.0, categories: []);

    } catch (e) {
      debugPrint("Error loading settings: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveSettings() async {
    final currentSettings = _settings;
    if (currentSettings == null) return;

    try {
      final file = await _getFile();
      final data = {
        "settings": [currentSettings.toJson()]
      };
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      debugPrint("Error saving settings: $e");
    }
  }

  void addCategoryTemplate(String name, double budget) {
    final currentSettings = _settings;
    if (currentSettings == null) return;

    final newCategory = CategoryStructureModel(
      name: name,
      monthlyBudget: budget,
    );

    currentSettings.categories.add(newCategory);

    notifyListeners();
    saveSettings();
  }

  void updateCategory(CategoryStructureModel cat, String newName, double newBudget) {
    cat.name = newName;
    cat.monthlyBudget = newBudget;

    notifyListeners();
    saveSettings();
  }

  void updateIncome(double newIncome) {
    final currentSettings = _settings;
    if (currentSettings == null) return;
    currentSettings.monthlyIncome = newIncome;

    saveSettings();
    notifyListeners();
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/settings.json');
  }
}