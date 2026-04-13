import 'month_model.dart';

class YearModel {
  final int year;
  final Map<int, MonthModel> months;

  const YearModel({
    required this.year,
    required this.months,
  });

  factory YearModel.empty(int year) {
    return YearModel(
      year: year,
      months: {},
    );
  }

  YearModel copyWith({
    int? year,
    Map<int, MonthModel>? months,
  }) {
    return YearModel(
      year: year ?? this.year,
      months: months ?? this.months,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'months': months.map(
            (key, value) => MapEntry(key.toString(), value.toJson()),
      ),
    };
  }

  factory YearModel.fromJson(Map<String, dynamic> json) {
    return YearModel(
      year: json['year'],
      months: (json['months'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(int.parse(key), MonthModel.fromJson(value)),
      ),
    );
  }
}
