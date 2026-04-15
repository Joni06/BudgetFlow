import 'category_structure_model.dart';

class SettingsModel {
  final double monthlyIncome;
  List<CategoryStructureModel> categories;

  SettingsModel({
    required this.monthlyIncome,
    required this.categories,
  });
}