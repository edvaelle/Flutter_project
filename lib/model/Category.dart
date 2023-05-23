import 'dart:convert';

class Category {
  final String title;

  Category({required this.title});

  factory Category.fromJson(String json) {
    return Category.fromString(jsonDecode(json));
  }

  static List<Category> fromJsonList(String json) {
    List<dynamic> jsonList = jsonDecode(json);
    List<Category> categoryList = [];
    for (var json in jsonList) {
      categoryList.add(Category.fromString(json));
    }
    return categoryList;
  }

  String toJson() {
    return jsonEncode(toString());
  }

  factory Category.fromString(String title) {
    return Category(title: title);
  }

  @override
  String toString() {
    return title;
  }
}
