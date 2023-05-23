import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Categories.dart';
import './PayBtn.dart';
import './Products.dart';
import './ProductsWithAppBar.dart';
import './login.dart';
import './storage/storage.dart';
import './api/api.dart';
import 'model/User.dart';

void main() {
  runApp(MyApp());
}
//wid prensipal app la,gen mod ki fet men ki pa paret
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  //retounen entefas itilizate a
  Widget build(BuildContext context) {
    //pou kreye yon eta global
    return ChangeNotifierProvider(
      //reprezante eta global
      create: (context) => MyAppState(),
      //defini tem aplikasyon an,defini sa kap monte avan(home)
      child: MaterialApp(
        //dezaktive mod debogaj
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: Home(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  //varyab prive ki stoke enfo itilizate ki konekte a
  User? _currentUser;

  MyAppState() {
    // pou jere koneksyon itilizate a
    loadLocalUser();
  }

  bool isLogin() {
    return _currentUser != null;
  }

  Future<void> login(User user) async {
    _currentUser = user;
    await Storage.saveUser(user);
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    await Storage.delUser();
    notifyListeners();
  }

  User? getUser() {
    return _currentUser;
  }

  Future<void> loadLocalUser() async {
    User? user = await Storage.getUser();
    if (user != null) {
      login(user);
    }
  }
}
// paj akey app la
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}
//eta interne paj akey la
class _HomeState extends State<Home> {
  //endex eleman aktyel
  int _index = 1;
  late List<Widget> _widgets;
  late Widget _current;
  late Key _key;

  @override
  void initState() {
    super.initState();
    _widgets = [_Cart(), _Home(), _Favorite()];
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
              child: state.isLogin()
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "OnlyShop",
                    style: appbarStyle,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Username:",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  Text(
                    state.getUser()!.username,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
                  : Text(
                "OnlyShop",
                style: appbarStyle,
              ),
            ),
            ListTile(
              title: Text("Login"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return Login();
                    },
                  ),
                );
              },
              enabled: !state.isLogin(),
            ),
            ListTile(
              title: Text("Product list"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return ProductsWithAppBar(
                        getProducts: APIService.getProducts,
                      );
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () {
                state.logout();
                setState(() {
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
        title: Text(
          "OnlyShop",
          style: appbarStyle,
        ),
        actions: [
          PayBtn(),
        ],
      ),
      body: Container(
        key: _key,
        child: _current,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _index = index;
            _current = _widgets[_index];
          });
        },
        currentIndex: _index,
        items: [
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

class _Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Categories(
              getCategories: APIService.getTopCategories,
            ),
            Products(
              getProducts: APIService.getTopProducts,
            ),
          ],
        ),
      ),
    );
  }
}

class _Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyAppState state = context.watch<MyAppState>();
    int userId = state.getUser()?.id ?? -1;

    return Products(
      getProducts: () {
        return Storage.getShopProducts(userId);
      },
    );
  }
}

class _Favorite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyAppState state = context.watch<MyAppState>();
    int userId = state.getUser()?.id ?? -1;

    return Products(
      getProducts: () {
        return Storage.getFavProducts(userId);
      },
    );
  }
}
