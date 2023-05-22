import 'package:http/http.dart' as http;
import 'dart:convert';

class APIService{

  static String _host = "https://fakestoreapi.com";

  static Future<dynamic> get(String url) async{
    final response = await http.get(Uri.parse(url));
    dynamic json = jsonDecode(response.body);
    return json;
  }
  
  static Future<http.Response> post(String url,Map<dynamic,dynamic> value) async{
    final response = await http.post(Uri.parse(url),
      headers: {
        "content-type" : "application/json",
      },
      body: jsonEncode(value),
    );
    return response;
  }

  static Future<bool> login(Map<dynamic,dynamic> value) async{
    final response =  await post("$_host/auth/login",value);
    if(response.statusCode==200 && jsonDecode(response.body)["token"]!=null){
      return true;
    }
    return false;
  }

  static Future<List> getProducts() async{
    return await get("$_host/products");
  }

  static Future<List> getTopProducts() async{
    return await get("$_host/products?sort=desc&limit=6");
  }

  static Future<List> getProductsByCategory(String categoryName) async{
    return await get("$_host/products/category/$categoryName");
  }

  static Future<List> getTopCategories() async{
    return await get("$_host/products/categories?sort=desc&limit=4");
  }

  static Future<dynamic> getUser(username) async{
    List users = await get("https://fakestoreapi.com/users");
    users.retainWhere((element) => element["username"]==username);
    return users[0];
  }

}