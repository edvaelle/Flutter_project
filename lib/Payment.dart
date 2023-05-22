import 'package:flutter/material.dart';

//paj peman
class Payment extends StatelessWidget{

  ButtonStyle _getStyleButton(color,context){
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width-300, 50),
        elevation: 5,
        shadowColor: color,
        shape : ContinuousRectangleBorder(borderRadius: BorderRadius.circular(50))
    );
    return buttonStyle;
  }

  @override
  Widget build(BuildContext context) {
      const titleAppbarStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    const double sizeBoxHeight = 50;
    double imageHeight = 100;
    double imageWidth = MediaQuery.of(context).size.width-300;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Pay",style: titleAppbarStyle,),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: _getStyleButton(Colors.red, context),
              onPressed: (){},
              child: Image.asset(
                "assets/images/moncash_logo.png",
                width: imageWidth,
                height: imageHeight,
              ),
            ),
            SizedBox(height: sizeBoxHeight,),
            ElevatedButton(
              style: _getStyleButton(Colors.blue, context),
              onPressed: (){},
              child: Image.asset(
                "assets/images/paypal_logo.png",
                width: imageWidth,
                height: imageHeight,
              ),
            ),
            SizedBox(height: sizeBoxHeight,),
            ElevatedButton(
              style: _getStyleButton(Colors.yellow, context),
              onPressed: (){},
              child: Image.asset(
                "assets/images/credit_card.png",
                width: imageWidth,
                height: imageHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }

}