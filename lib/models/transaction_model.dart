class TransactionModel {
  final int id;
  final double amount;
  final String note;
  final int categoryId;
  final DateTime date;
  final bool repeatMonthly;

  TransactionModel({
    int? id,
    required this.amount,
    required this.note,
    required this.categoryId,
    required this.date,
    required this.repeatMonthly,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  TransactionModel copyWith({
    double? amount,
    String? note,
    int? categoryId,
    int? categoryVersion,
    DateTime? date,
    bool? repeatMonthly,
  }) {
    return TransactionModel(
      id: id,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      repeatMonthly: repeatMonthly ?? this.repeatMonthly,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'note': note,
      'categoryId': categoryId,
      'date': date,
      'repeatMonthly': repeatMonthly
    };
  }
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'],
      categoryId: json['categoryId'],
      date: DateTime.parse(json['date']),
      repeatMonthly: json['repeatMonthly'],
    );
  }
}