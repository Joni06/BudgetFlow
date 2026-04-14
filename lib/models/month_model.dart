import 'category_model.dart';
import 'transaction_model.dart';

class MonthModel {
  final int month;
  final double budget;
  final double income;
  final List<CategoryModel> categories;
  final List<TransactionModel> transactions;

  MonthModel({
    required this.month,
    required this.budget,
    required this.income,
    required this.categories,
    required this.transactions,
  });

  factory MonthModel.empty(int month) {
    return MonthModel(
      month: month,
      budget: 0.0,
      income: 0.0,
      categories: [],
      transactions: [],
    );
  }

  MonthModel copyWith({
    int? month,
    double? budget,
    List<CategoryModel>? categories,
    List<TransactionModel>? transactions,
  }) {
    return MonthModel(
      month: month ?? this.month,
      budget: budget ?? this.budget,
      income: income ?? this.income,
      categories: categories ?? this.categories,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'budget': budget,
      'income': income,
      'categories': categories.map((c) => c.toJson()).toList(),
      'transactions': transactions.map((t) => t.toJson()).toList(),
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
      transactions: (json['transactions'] as List)
          .map((t) => TransactionModel.fromJson(t))
          .toList(),
    );
  }
}
