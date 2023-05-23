import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import 'Payment.dart';

class PayBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyAppState appState = context.watch<MyAppState>();
    TextStyle appbarStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    return TextButton(
      onPressed: (){
        if(appState.isLogin()){
            Navigator.push(context, MaterialPageRoute(
                builder: (ctx){ return Payment();}
            )
          );
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You must to connected")));
        }
      },
      child: Text("Pay", style: appbarStyle,),
    );
  }
}