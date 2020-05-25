import 'package:dream_planner/ui/splash/splash_ui.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Raleway",
        primarySwatch: Colors.lightBlue,
      ),
      home: SplashScreen(),
    );
  }
}