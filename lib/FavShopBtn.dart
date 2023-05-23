import './storage/storage.dart';
import 'package:flutter/material.dart';

//bouton pou ajoute nan favori ak nan panye
class FavShopBtn extends StatefulWidget{
  final int userId;

  final int productId;

  const FavShopBtn({super.key, required this.userId, required this.productId});

  @override
  State<StatefulWidget> createState() {
    return _FavShopBtnState();
  }
}

class _FavShopBtnState extends State<FavShopBtn>{

  late Future<bool> isFavorite;
  late Future<bool> isShopping;

  @override
  void initState() {
    super.initState();
    isFavorite = Storage.isProductInFav(widget.userId,widget.productId);
    isShopping = Storage.isProductInShop(widget.userId,widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    const double iconSize = 30;
    return Row(
      children: [
        FutureBuilder(
            future: isShopping,
            builder: (context,result){
              if(result.hasData){
                return IconButton(
                  onPressed: () async{
                    if(widget.userId!=-1){
                      await Storage.toggleProductInShop(widget.userId,widget.productId);
                      setState(() {
                        isShopping = Storage.isProductInShop(widget.userId,widget.productId);
                      });
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("you must to connected to add to shopping")));
                    }
                  },
                  color: Colors.blue,
                  icon: result.data! ? Icon(Icons.shopping_cart,size: iconSize,) : Icon(Icons.shopping_cart_outlined,size: iconSize,),
                );
              }
              else if(result.hasError){
                return Text("${result.error}");
              }
              else{
                return CircularProgressIndicator();
              }
            }
        ),
        SizedBox(width: 5,),
        FutureBuilder(
            future: isFavorite,
            builder: (context,result){
              if(result.hasData){
                return IconButton(
                  icon: result.data! ? Icon(Icons.favorite,size: iconSize,) : Icon(Icons.favorite_border,size: iconSize,),
                  color: Colors.red,
                  onPressed: () async{
                    if(widget.userId!=-1) {
                      await Storage.toggleProductInFav(widget.userId,widget.productId);
                      setState(() {
                        isFavorite = Storage.isProductInFav(widget.userId,widget.productId);
                      });
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("you must to connected to add to favorite")));
                    }
                  },
                );
              }
              else if(result.hasError){
                return Text("${result.error}");
              }
              else{
                return CircularProgressIndicator();
              }
            }
        ),
      ],
    );
  }

}