import 'package:buget_flow/models/transaction_model.dart';

class CategoryModel {
  final int id;
  final String name;
  final double monthlyBudget;
  final double spent;
  final List<TransactionModel> transactions;

  CategoryModel({
    required this.id,
    required this.name,
    required this.monthlyBudget,
    required this.spent,
    required this.transactions,
  });

  CategoryModel copyWith({
    int? id,
    String? name,
    double? monthlyBudget,
    double? spent,
    List<TransactionModel>? transactions,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      spent: spent ?? this.spent,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'monthlyBudget': monthlyBudget,
      'spent': spent,
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      monthlyBudget: (json['monthlyBudget'] as num).toDouble(),
      spent: (json['spent'] as num).toDouble(),
      transactions: (json['transactions'] as List)
          .map((t) => TransactionModel.fromJson(t))
          .toList(),
    );
  }
}
