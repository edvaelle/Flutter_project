import 'package:flutter/material.dart';
import './PayBtn.dart';
import 'FavShopBtn.dart';

//afiche detay sou yon pwodwi
class Product extends StatelessWidget {
  final int productId;
  final String name;
  final String imageUrl;
  final String price;
  final String description;
  final String category;
  final int userId;

  const Product({super.key, required this.name, required this.imageUrl, required this.price, required this.description, required this.category, required this.productId, required this.userId});


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
                category,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue
                ),
              ),
              SizedBox(height: sizeBoxHeight),
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 300,
                width: double.infinity,
              ),
              SizedBox(height: sizeBoxHeight),
              Text(
                name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: sizeBoxHeight),
              SizedBox(height: sizeBoxHeight),
              Text(
                'Pri: $price HTG',
                style: TextStyle(fontSize: 20,color: Colors.green,),
              ),
              SizedBox(height: sizeBoxHeight),
              FavShopBtn(userId: userId, productId: productId),
              SizedBox(height: sizeBoxHeight),
              Text(
                description,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}