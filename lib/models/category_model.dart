class CategoryModel {
  final int id;
  final int version;
  final String name;
  final double monthlyBudget;

  const CategoryModel({
    required this.id,
    required this.version,
    required this.name,
    required this.monthlyBudget,
  });

  CategoryModel copyWith({
    int? id,
    int? version,
    String? name,
    double? monthlyBudget,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      version: version ?? this.version,
      name: name ?? this.name,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'name': name,
      'monthlyBudget': monthlyBudget,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      version: json['version'],
      name: json['name'],
      monthlyBudget: (json['monthlyBudget'] as num).toDouble(),
    );
  }
}
