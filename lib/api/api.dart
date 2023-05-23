import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/Category.dart';
import '../model/Product.dart';
import '../model/User.dart';

class APIService {
  static String _host = "https://fakestoreapi.com";

  static Future<dynamic> get(String url) async {
    final response = await http.get(Uri.parse(url));
    dynamic json = jsonDecode(response.body);
    return json;
  }

  static Future<http.Response> post(String url, Map<dynamic, dynamic> value) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
      },
      body: jsonEncode(value),
    );
    return response;
  }

  static Future<bool> login(Map<dynamic, dynamic> value) async {
    final response = await post("$_host/auth/login", value);
    if (response.statusCode == 200 && jsonDecode(response.body)["token"] != null) {
      return true;
    }
    return false;
  }

  static Future<List<Product>> getProducts() async {
    dynamic productList = await get("$_host/products");
    List<Product> products = [];
    for (var productJson in productList) {
      Product product = Product.fromMap(productJson);
      products.add(product);
    }
    return products;
  }

  static Future<List<Product>> getTopProducts() async {
    dynamic topProductList = await get("$_host/products?sort=desc&limit=6");
    List<Product> topProducts = [];
    for (var productJson in topProductList) {
      Product product = Product.fromMap(productJson);
      topProducts.add(product);
    }
    return topProducts;
  }

  static Future<List<Product>> getProductsByCategory(String categoryName) async {
    dynamic productList = await get("$_host/products/category/$categoryName");
    List<Product> products = [];
    for (var productJson in productList) {
      Product product = Product.fromMap(productJson);
      products.add(product);
    }
    return products;
  }

  static Future<List<Category>> getTopCategories() async {
    dynamic topCategoryList = await get("$_host/products/categories?sort=desc&limit=4");
    List<Category> topCategories = [];
    for (var categoryJson in topCategoryList) {
      Category category = Category.fromString(categoryJson);
      topCategories.add(category);
    }
    return topCategories;
  }

  static Future<User> getUser(String username) async {
    dynamic userList = await get("https://fakestoreapi.com/users");
    for (var userJson in userList) {
      User user = User.fromMap(userJson);
      if (user.username == username) {
        return user;
      }
    }
    throw Exception('User not found');
  }
}
