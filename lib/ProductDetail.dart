import 'package:flutter/material.dart';
import './PayBtn.dart';
import './FavShopBtn.dart';
import 'model/Product.dart';
import 'model/User.dart';

//afiche detay sou yon pwodwi
class ProductDetail extends StatelessWidget {
  final Product product;
  final int userId;

  const ProductDetail({super.key, required this.product, required this.userId});

  @override
  Widget build(BuildContext context) {
    TextStyle appbarStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    const double sizeBoxHeight = 10;
    return  Scaffold(
      appBar: AppBar(
        title: Text('Product detail',style: appbarStyle,),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PayBtn(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.category!.title,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue
                ),
              ),
              SizedBox(height: sizeBoxHeight),
              Image.network(
                product.image!,
                fit: BoxFit.cover,
                height: 300,
                width: double.infinity,
              ),
              SizedBox(height: sizeBoxHeight),
              Text(
                product.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: sizeBoxHeight),
              SizedBox(height: sizeBoxHeight),
              Text(
                'Pri: ${product.price} HTG',
                style: TextStyle(fontSize: 20,color: Colors.green,),
              ),
              SizedBox(height: sizeBoxHeight),
              FavShopBtn(productId: product.id, userId: userId,),
              SizedBox(height: sizeBoxHeight),
              Text(
                product.description!,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
