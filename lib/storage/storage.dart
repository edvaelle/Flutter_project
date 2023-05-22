import 'package:localstorage/localstorage.dart';

import '../api/api.dart';

class Storage{

  static String _file = "fakestoreapi.json";
  static String _favKey = "fav";
  static String _shopKey = "shop";
  static String _userKey = "user";
  static LocalStorage _storage = LocalStorage(_file);

  static Future<void> saveUser(Map<String,dynamic> user) async {
    await _storage.ready;
    await _storage.setItem(_userKey, user);
  }

  static Future<void> delUser() async {
    await _storage.ready;
    await _storage.deleteItem(_userKey);
  }

  static Future<Map<String,dynamic>> getUser() async {
    await _storage.ready;
    return await _storage.getItem(_userKey) ?? {};
  }

  //rekipere lis pwodwi ki nan favori ou byen nan panye
  static Future<List> _getFavShopProducts(String key) async{
    await _storage.ready;
    //rekipere id pwodwi ki te la yo
    List idList = await _storage.getItem(key) ?? [];
    //rekipere lis pwodwi ki sou api la
    final List products =  await APIService.getProducts();
    //filtre pwodwi sa yo a pati lis id nou rekipere yo
    products.retainWhere((element) => idList.contains(element["id"]));
    return products;
  }

  //ajoute ou byn retire nan favori ou nan panye
  static Future<void> _toggleFavShopProduct(String key,dynamic value) async{
    await _storage.ready;
    //rekipere lis id pwodwi yo
    List<dynamic> idList = await _storage.getItem(key) ?? [];
    //si pwodwi yo nan lis nou retirel si l pa nan lis nou ajoutel
    if(idList.contains(value)){
      idList.remove(value);
    }
    else{
      idList.add(value);
    }
    //apre nou remete lis la nan fichye a
    await _storage.setItem(key,idList);
  }

  //verifye si pwodwi nan favori ou byen nan panye
  static Future<bool> _isProductInFavShop(String key,productId) async{
    await _storage.ready;
    List idList = await _storage.getItem(key) ?? [];
    return idList.contains(productId);
  }

  //rekipere tout pwodwi ki nan favori
  static Future<List> getFavProducts(int userId) async{
    return await _getFavShopProducts("$userId$_favKey");
  }

  //ajoute ou byen retire nan favori
  static Future<void> toggleProductInFav(int userId,dynamic value) async{
    await _toggleFavShopProduct("$userId$_favKey",value);
  }

  //verifye si yon pwodwi nan favori
  static Future<bool> isProductInFav(int userId,int productId) async{
    return await _isProductInFavShop("$userId$_favKey", productId);
  }

  //rekipere tout pwodwi ki nan panye
  static Future<List> getShopProducts(int userId) async{
    return await _getFavShopProducts("$userId$_shopKey");
  }

  //ajoute ou byen retire nan panye
  static Future<void> toggleProductInShop(int userId,dynamic value) async{
    await _toggleFavShopProduct("$userId$_shopKey",value);
  }

  //verifye si yon pwodwi nan panye
  static Future<bool> isProductInShop(int userId,int productId) async{
    return await _isProductInFavShop("$userId$_shopKey", productId);
  }
}