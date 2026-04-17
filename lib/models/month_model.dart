import 'category_model.dart';

class MonthModel {
  final int month;
  final double budget;
  final double income;
  final double spent;
  final List<CategoryModel> categories;

  MonthModel({
    required this.month,
    required this.budget,
    required this.income,
    required this.spent,
    required this.categories,
  });

  factory MonthModel.empty(int month) {
    return MonthModel(
      month: month,
      budget: 0.0,
      income: 0.0,
      spent: 0.0,
      categories: [],
    );
  }

  MonthModel copyWith({
    int? month,
    double? budget,
    double? income,
    double? spent,
    List<CategoryModel>? categories,
  }) {
    return MonthModel(
      month: month ?? this.month,
      budget: budget ?? this.budget,
      income: income ?? this.income,
      spent: spent ?? this.spent,
      categories: categories ?? this.categories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'budget': budget,
      'income': income,
      'spent': spent,
      'categories': categories.map((c) => c.toJson()).toList(),
    };
  }

  factory MonthModel.fromJson(Map<String, dynamic> json) {
    return MonthModel(
      month: json['month'],
      budget: (json['budget'] as num).toDouble(),
      income: (json['income'] as num).toDouble(),
      spent: (json['spent'] as num).toDouble(),
      categories: (json['categories'] as List)
          .map((c) => CategoryModel.fromJson(c))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'MonthModel(month: $month, budget: $budget, income: $income, spent: $spent, categories: ${categories.toString()})';
  }
}
