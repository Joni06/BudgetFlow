class CategoryStructureModel {
  final int id;
  final int version;
  final String name;
  final double monthlyBudget;

  CategoryStructureModel({
    required this.id,
    this.version = 0,
    required this.name,
    required this.monthlyBudget,
  });

  CategoryStructureModel copyWith({String? name, double? monthlyBudget}) {
    return CategoryStructureModel(
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

  factory CategoryStructureModel.fromJson(Map<String, dynamic> json) {
    return CategoryStructureModel(
      id: json['id'],
      version: json['version'],
      name: json['name'],
      monthlyBudget: (json['monthlyBudget'] as num).toDouble(),
    );
  }
}
