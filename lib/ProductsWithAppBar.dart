import 'package:flutter/material.dart';
import './PayBtn.dart';
import './Products.dart';
import 'model/Product.dart';

// Affiche la liste des produits avec une appbar
class ProductsWithAppBar extends StatelessWidget {
  final Future<List<Product>> Function() getProducts;

  ProductsWithAppBar({Key? key, required this.getProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle appbarStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Product List",
          style: appbarStyle,
        ),
        actions: [
          PayBtn(),
        ],
      ),
      body: Products(getProducts: getProducts),
    );
  }
}
