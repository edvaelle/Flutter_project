import 'package:localstorage/localstorage.dart';
import '../api/api.dart';
import '../model/Product.dart';
import '../model/User.dart';

class Storage {
  static String _file = "fakestoreapi.json";
  static String _favKey = "fav";
  static String _shopKey = "shop";
  static String _userKey = "user";
  static LocalStorage _storage = LocalStorage(_file);

  static Future<void> saveUser(User user) async {
    await _storage.ready;
    await _storage.setItem(_userKey, user.toJson());
  }

  static Future<void> delUser() async {
    await _storage.ready;
    await _storage.deleteItem(_userKey);
  }

  static Future<User?> getUser() async {
    await _storage.ready;
    dynamic userJson = await _storage.getItem(_userKey);
    if (userJson != null) {
      User user = User.fromJson(userJson);
      return user;
    }
    return null;
  }

  static Future<List<Product>> _getFavShopProducts(String key) async {
    await _storage.ready;
    List<dynamic> idList = await _storage.getItem(key) ?? [];
    List<Product> products = await APIService.getProducts();
    List<Product> filteredProducts = [];
    for (var product in products) {
      if (idList.contains(product.id)) {
        filteredProducts.add(product);
      }
    }
    return filteredProducts;
  }

  static Future<void> _toggleFavShopProduct(String key, dynamic value) async {
    await _storage.ready;
    List<dynamic> idList = await _storage.getItem(key) ?? [];
    if (idList.contains(value)) {
      idList.remove(value);
    } else {
      idList.add(value);
    }
    await _storage.setItem(key, idList);
  }

  static Future<bool> _isProductInFavShop(String key, int productId) async {
    await _storage.ready;
    List<dynamic> idList = await _storage.getItem(key) ?? [];
    return idList.contains(productId);
  }

  static Future<List<Product>> getFavProducts(int userId) async {
    return await _getFavShopProducts("$userId$_favKey");
  }

  static Future<void> toggleProductInFav(int userId, int productId) async {
    await _toggleFavShopProduct("$userId$_favKey", productId);
  }

  static Future<bool> isProductInFav(int userId, int productId) async {
    return await _isProductInFavShop("$userId$_favKey", productId);
  }

  static Future<List<Product>> getShopProducts(int userId) async {
    return await _getFavShopProducts("$userId$_shopKey");
  }

  static Future<void> toggleProductInShop(int userId, int productId) async {
    await _toggleFavShopProduct("$userId$_shopKey", productId);
  }

  static Future<bool> isProductInShop(int userId, int productId) async {
    return await _isProductInFavShop("$userId$_shopKey", productId);
  }
}
