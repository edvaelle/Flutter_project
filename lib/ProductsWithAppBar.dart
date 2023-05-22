import 'package:flutter/material.dart';
import './PayBtn.dart';
import './Products.dart';

//afiche lis pwodwi yo avek yon appbar
class ProductsWithAppBar extends StatelessWidget{

  final Future<List> Function() getProducts;

  ProductsWithAppBar({super.key, required this.getProducts, });

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
        title: Text("Product List",style: appbarStyle,),
        actions: [
          PayBtn(),
        ],
      ),
      body: Products(getProducts: getProducts),
    );
  }

}