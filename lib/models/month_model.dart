import 'category_model.dart';

class MonthModel {
  final int month;
  final double budget;
  final double income;
  final List<CategoryModel> categories;

  MonthModel({
    required this.month,
    required this.budget,
    required this.income,
    required this.categories,
  });

  factory MonthModel.empty(int month) {
    return MonthModel(
      month: month,
      budget: 0.0,
      income: 0.0,
      categories: [],
    );
  }

  MonthModel copyWith({
    int? month,
    double? budget,
    double? income,
    List<CategoryModel>? categories,
  }) {
    return MonthModel(
      month: month ?? this.month,
      budget: budget ?? this.budget,
      income: income ?? this.income,
      categories: categories ?? this.categories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'budget': budget,
      'income': income,
      'categories': categories.map((c) => c.toJson()).toList(),
    };
  }

  factory MonthModel.fromJson(Map<String, dynamic> json) {
    return MonthModel(
      month: json['month'],
      budget: (json['budget'] as num).toDouble(),
      income: (json['income'] as num).toDouble(),
      categories: (json['categories'] as List)
          .map((c) => CategoryModel.fromJson(c))
          .toList(),
    );
  }
}
