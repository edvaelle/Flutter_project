import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Product.dart';
import 'FavShopBtn.dart';
import 'main.dart';

//liste pwodwi yo
class Products extends StatefulWidget{
  final Future<List> Function() getProducts;

  Products({super.key, required this.getProducts});

  @override
  State<StatefulWidget> createState() {
    return _ProductsState();
  }

}

class _ProductsState extends State<Products>{

  late Future<List> _products;
  late Key _key;

  @override
  void initState(){
    super.initState();
    _products = widget.getProducts();
    _key = UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    MyAppState appState = context.watch<MyAppState>();
    return FutureBuilder<List>(
      key: _key,
      future: _products,
      builder: (context,products){
        if(products.hasData){
          //si lis pwodwi yo vid affiche yon mesaj pou di pa gen pwodwi pou afiche
          if(products.data!.isEmpty) {
            return Center(
                child: Text(
                  "Not products to display",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
            );
          }
          else{
            return SingleChildScrollView(
              child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.7,
                  padding: EdgeInsets.all(10),
                  children: products.data!.map((product) =>
                      GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (ctx) {
                                  return Product(
                                    userId: appState.isLogin() ? appState.getUser()["id"] : -1,
                                    name: product["title"],
                                    imageUrl: product["image"],
                                    price: product["price"].toString(),
                                    category: product["category"],
                                    description: product["description"],
                                    productId: product["id"],
                                  );
                                }
                            )
                            ).whenComplete((){
                              //refresh paj la
                              setState(() {
                                _key = UniqueKey();
                              });
                            });
                          },
                          child : _ProductCard(
                            userId: appState.isLogin() ? appState.getUser()["id"] : -1,
                            name: product["title"],
                            imageUrl: product["image"],
                            price: product["price"].toString(),
                            category: product["category"],
                            description: product["description"],
                            productId: product["id"],
                          )
                      )
                  ).toList()
              ),
            );
          }
        }
        else if(products.hasError){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("${products.error}"),
              SizedBox(height: 10),
              ElevatedButton(
              onPressed: (){
                //rechaje paj la nan ka ki gen ere
                setState(() {
                  _products = widget.getProducts();
                  _key = UniqueKey();
                });
              },
              child: Text("Retry")),
              ],
            ),
          );
        }
        else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

}

class _ProductCard extends StatelessWidget {
  final int userId;
  final int productId;
  final String name;
  final String imageUrl;
  final String price;
  final String description;
  final String category;

  _ProductCard({required this.name, required this.imageUrl, required this.price, required this.description, required this.category, required this.productId, required this.userId,});


  @override
  Widget build(BuildContext context) {
    const double height = 5;
    return SizedBox(
      height: double.infinity,
      child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      height: 160,
                      width: double.infinity,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: height),
                    Text(
                      "$price HTG",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    FavShopBtn(userId: userId, productId: productId),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
