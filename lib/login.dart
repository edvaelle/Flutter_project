import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './api/api.dart';
import '../../main.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }

}

class _LoginState extends State<Login>{

  final _formKey = GlobalKey<FormState>();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _error = "";
  bool _progressbar = false; // si progress bar lan dwe afiche ou non

  @override
  Widget build(BuildContext context) {
    MyAppState appState = context.watch<MyAppState>();
    TextStyle appbarStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    const double sizeBoxHeight = 40;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Login",style: appbarStyle,),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: sizeBoxHeight,),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Input your username"
                    ),
                    controller: _userNameController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Answer required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: sizeBoxHeight,),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Input your password"
                    ),
                    obscuringCharacter: "*",
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Answer required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: sizeBoxHeight,),
                  _progressbar ? LinearProgressIndicator() : Text(_error,style: TextStyle(color: Colors.red,fontSize: 20),),
                  SizedBox(height: sizeBoxHeight,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 40),
                        shape : ContinuousRectangleBorder(borderRadius: BorderRadius.circular(5.0))
                    ),
                    onPressed: () async{
                      setState(() {
                        _progressbar = true;
                      });
                      if(_formKey.currentState!.validate()) {
                        String username = _userNameController.text;
                        String password = _passwordController.text;
                        Map<String, String> loginInfo = {
                          "username" : username,
                          "password" : password,
                        };
                        bool response = await APIService.login(loginInfo);
                        if(response){
                          dynamic user = await APIService.getUser(username);
                          await appState.login(user);
                          setState(() {
                            _error = "";
                          });
                          _navigateToLoginSucces();
                        }
                        else{
                          setState(() {
                            _error = "Username or password incorrect";
                          });
                        }
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("data is not correct")));
                      }
                      setState(() {
                        _progressbar = false;
                      });
                    },
                    child: Text("Login"),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  void _navigateToLoginSucces(){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(
        builder: (ctx){ return _LoginSucces();}
    )
    );
  }
}

class _LoginSucces extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    TextStyle appbarStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    const textStyle = TextStyle(
      fontSize: 20,
      color: Colors.white,
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Login",style: appbarStyle,),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.green,
                child : Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text("Connected",style: textStyle,),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(MediaQuery.of(context).size.width/2, 50),
                      shape : ContinuousRectangleBorder(borderRadius: BorderRadius.circular(5.0))
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (ctx){ return Home();}
                      )
                    );
                  },
                  child: Text("return to home page"),
                ),
              ),
            ],
          ),
        )
    );
  }
}