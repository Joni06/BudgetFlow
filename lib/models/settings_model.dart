import 'category_structure_model.dart';

class SettingsModel {
  double monthlyIncome;
  List<CategoryStructureModel> categories;

  SettingsModel({
    required this.monthlyIncome,
    required this.categories,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      monthlyIncome: (json['incomeMonthly'] as num).toDouble(),
      categories: (json['categorys'] as List)
          .map((c) => CategoryStructureModel.fromJson(c))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'incomeMonthly': monthlyIncome,
      'categorys': categories.map((c) => c.toJson()).toList(),
    };
  }
}