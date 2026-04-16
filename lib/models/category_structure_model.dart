class CategoryStructureModel {
  final int id;
  String name;
  double monthlyBudget;

  CategoryStructureModel({
    int ? id,
    required this.name,
    required this.monthlyBudget,
  }): id = id ?? DateTime.now().millisecondsSinceEpoch;

  CategoryStructureModel copyWith({String? name, double? monthlyBudget}) {
    return CategoryStructureModel(
      id: id,
      name: name ?? this.name,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'monthlyBudget': monthlyBudget,
    };
  }

  factory CategoryStructureModel.fromJson(Map<String, dynamic> json) {
    return CategoryStructureModel(
      id: json['id'],
      name: json['name'],
      monthlyBudget: (json['monthlyBudget'] as num).toDouble(),
    );
  }
}
