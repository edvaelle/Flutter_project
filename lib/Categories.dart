import 'package:flutter/material.dart';
import './ProductsWithAppBar.dart';
import './api/api.dart';
import 'model/Category.dart';

//affiche lis kategori
class Categories extends StatefulWidget{

  final Future<List<Category>> Function() getCategories ;

  Categories({super.key, required this.getCategories});

  @override
  State<StatefulWidget> createState() {
    return _CategoriesState();
  }

}

class _CategoriesState extends State<Categories>{

  late Future<List<Category>> _categories;
  late Key _key;

  @override
  void initState(){
    super.initState();
    _categories = widget.getCategories();
    _key = UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<List>(
          key: _key,
          future: _categories,
          builder: (context,categoryList){
            if(categoryList.hasData){
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                children: categoryList.data!.map((
                    category) => _CategoryCard(category: category
                )).toList(),
              );
            }
            else if(categoryList.hasError){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${categoryList.error}"),
                    SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: (){
                          //refresh paj la
                          setState(() {
                            _categories = widget.getCategories();
                            _key = UniqueKey();
                          });
                        },
                        child: Text("Retry")),
                  ],
                ),
              );
            }
            else {
              return CircularProgressIndicator();
            }
          }
        )
    );
  }

}

class _CategoryCard extends StatelessWidget{

  final Category category;

  _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
    );
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (ctx){ return ProductsWithAppBar(getProducts: () {
                return APIService.getProductsByCategory(category.title);
              });
            }
          )
        );
      },
      child: Card(
        color: Colors.black26,
        child : Padding(
            padding: const EdgeInsets.all(20),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 70,
                ),
                Text(category.title,style: textStyle)
              ],
            )
        ),
      ),
    );
  }

}