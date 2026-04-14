class CategoryModel {
  final int id;
  final int version;
  final String name;
  final double monthlyBudget;

  CategoryModel({
    required this.id,
    this.version = 0,
    required this.name,
    required this.monthlyBudget,
  });

  CategoryModel copyWith({String? name, double? monthlyBudget}) {
    return CategoryModel(
      id: this.id,
      version: this.version + 1,
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
