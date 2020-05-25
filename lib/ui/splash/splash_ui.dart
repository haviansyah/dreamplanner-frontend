import 'package:dream_planner/ui/colors.dart';
import 'package:dream_planner/ui/main/main_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
        return new MainScreen();
      }));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             Image.asset("assets/images/logo.png",width: 120,),
             Padding(padding: EdgeInsets.all(34)),
             Text("Dream",style: TextStyle(fontFamily: "Pacifico",fontSize: 34,color: DpColors.primaryDark),),
             Text("P L A N N E R",style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),
      )
    );
  }
}