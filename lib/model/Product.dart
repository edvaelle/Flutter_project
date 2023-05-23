import 'dart:convert';

import 'Category.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final Category? category;
  final String? description;
  final String? image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    this.category,
    this.description,
    this.image,
  });

  factory Product.fromJson(String json) {
    return Product.fromMap(jsonDecode(json));
  }

  static List<Product> fromJsonList(String json) {
    List<dynamic> jsonList = jsonDecode(json);
    List<Product> productList = [];
    for (var json in jsonList) {
      productList.add(Product.fromMap(json));
    }
    return productList;
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      title: map['title'],
      price: double.parse("${map['price']}"),
      category: map['category'] != null ? Category.fromString(map['category']) : null,
      description: map['description'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'category': category?.toString(),
      'description': description,
      'image': image,
    };
  }
}

