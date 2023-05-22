import 'package:flutter/material.dart';
import './Categories.dart';
import './PayBtn.dart';
import './Products.dart';
import './ProductsWithAppBar.dart';
import './login.dart';
import 'package:provider/provider.dart';
import './storage/storage.dart';
import './api/api.dart';

void main() {
  //pou lanse aplikasyon an
  runApp(MyApp());
}
//widget principal
class MyApp extends StatelessWidget {
  //pou idantifye widget principal la
  MyApp({super.key});

  @override
  //build la pemet ou retounen yon widget
  Widget build(BuildContext context) {
    //changenotifierprovider a se yon varyab global pou tout aplikasyon an, li la poul kreye state global la
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child : MaterialApp(
        debugShowCheckedModeBanner: false,
        //pou defini couleur principal
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        //se home sa ki di men ki widget kap afiche
          //widget prensipal la se home
        home: Home(),
      )
    );
  }
}

class MyAppState extends ChangeNotifier {
//sa se yon constructeur
  MyAppState(){
    //konekte ak done ki t preanrejistre pou yon itilizate si genyen
    //pou si li t konekte deja
    loadLocalUser();
  }
// currentuser a se index eleman ki seleksyone a
  //string lan kom kle, dynamic lan se pou li ka pran nenpot valeur
  Map<String, dynamic> _currentUser = {};

  //verifye si gen yon itilizate ki konekete
  bool isLogin(){
    if(_currentUser.isEmpty){
      return false;
    }
    else{
      return true;
    }
  }

  //konekte yon itilizate
  Future<void> login(Map<String, dynamic> currentUser) async{
    _currentUser = currentUser;
    //anrejistre itilizate ki konekte a an lokal
    await Storage.saveUser(_currentUser);
    //aveti ke currentUser a chanje
    notifyListeners();
  }

  //dekonekte yon itilizate
  Future<void> logout() async{
    _currentUser.clear();
    //siprimer itilizate ki konekte a an lokal
    await Storage.delUser();
    notifyListeners();
  }

  //rekipere itilizate aktyel la
  Map<String, dynamic> getUser(){
    return _currentUser;
  }

  //chaje itilizate ki anrejistre an local la
  Future<void> loadLocalUser() async{
    //rekipere itlizate ki an local la
    Map<String,dynamic> user = await Storage.getUser();
    login(user);
  }

}


//paj akey la
class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home>{

  late int _index;
  late List<Widget> _widgets;
  late Widget _current;
  // late la vle di ke kle a dwe initialize avan li utilize
  late Key _key;

  @override
  void initState(){
    super.initState();
    _index = 1;
    //liste widgets
    _widgets = [_Cart(),_Home(),_Favorite()];
    //eleman ki fek seleksyone a
    _current = _widgets[_index];
    _key = UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    MyAppState state = context.watch<MyAppState>();
    TextStyle appbarStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: state.isLogin() ?
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Only Shop",style: appbarStyle,),
                  SizedBox(height: 30,),
                  Text(
                    "Username:",
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.cyanAccent),
                  ),
                  Text(
                    state.getUser()["username"],
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ],
              ) : Text("Only Shop",style: appbarStyle,),
            ),
            ListTile(
              title: Text("Login"),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                    builder: (ctx){ return Login();}
                )
                );
              },
              enabled: !state.isLogin(),
            ),
            ListTile(
              title: Text("Product list"),
              onTap: (){
                //pou retounenw kotew t ye a
                Navigator.pop(context);
                //pou voyew nan yon lot paj
                Navigator.push(context, MaterialPageRoute(
                    builder: (ctx){ return ProductsWithAppBar(getProducts: APIService.getProducts,);}
                )
                );
              },
            ),
            ListTile(
              title: Text("Logout"),
              onTap: (){
                state.logout();
                setState(() {
                  //rafrechi paj la, pou jenere kle a chak fwa user a vle rekonekte
                  _key = UniqueKey();
                });
              },
              enabled: state.isLogin(),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Only Shop",style: appbarStyle,),
        actions: [
          PayBtn(),
        ],
      ),
      body: Container(
        key: _key,
        child : _current,
      ),
      //widget paran ki affiche eleman nan barre de navigation anba paj la
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          //chanje widget kouran an
          setState(() {
            _index = index;
            _current = _widgets[_index];
          });
        },
        currentIndex: _index,
        items: [
          //li prezante eleman nan barre navigation an ex: Home
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
        ],
      ),
    );
  }
}

class _Home extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Center(
      child:SingleChildScrollView(
        child:Column(
          children: [
            Categories(getCategories: APIService.getTopCategories,),
            Products(getProducts: APIService.getTopProducts),
          ],
        ),
      )
    );
  }

}

class _Cart extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    MyAppState state = context.watch<MyAppState>();
    if(state.isLogin()){
      return Products(getProducts: () {
        return Storage.getShopProducts(state.getUser()["id"]);
      });
    }
    else{
      return Products(getProducts: () {
        return Storage.getShopProducts(-1);
      });
    }
  }
}

class _Favorite extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    MyAppState state = context.watch<MyAppState>();
    if(state.isLogin()){
      return  Products(getProducts: () {
        return Storage.getFavProducts(state.getUser()["id"]);
      });
    }
    else{
      return  Products(getProducts: () {
        return Storage.getFavProducts(-1);
      });
    }
  }
}