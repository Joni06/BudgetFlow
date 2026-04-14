import '../models/category_model.dart';

int searchNewestVersion({
  required int categoryId,
  required List<CategoryModel> categories,
}){
  int newestVersion = 0;
  for (final category in categories) {
    if (category.id == categoryId) {
      if (category.version > newestVersion) {
        newestVersion = category.version;
      }
    }
  }
  return newestVersion;
}