import 'category_model.dart';

class SettingsModel {
  final double monthlyIncome;
  List<CategoryModel> categories;

  SettingsModel({
    required this.monthlyIncome,
    required this.categories,
  });
}