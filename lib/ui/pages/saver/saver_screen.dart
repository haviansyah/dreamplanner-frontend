import 'dart:ui';

import 'package:dream_planner/ui/colors.dart';
import 'package:dream_planner/ui/text_style.dart';
import 'package:flutter/material.dart';
import 'package:dream_planner/ui/util/helper.dart';

class SaverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.only(top: 34, left: 13, right: 13),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Good ${Helper.greeting()}, Haviansyah",style: DpText.body,),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical:0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Money Saver",style: DpText.title,),
                                  IconButton(icon: Icon(Icons.add, color: DpColors.primaryDark,),onPressed: (){},padding: EdgeInsets.all(21),)
                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                      buildList()


                    ]
                )
            )
        )
    );
  }

  Widget buildList(){
    return Expanded(
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.only(bottom : 13),
            child: buildSaverCard(context),
          );
        }
      ),
    );
  }

  Widget buildSaverCard(context){
    var width = MediaQuery.of(context).size.width - 68;
    var height = width * (2/3);
    return new Container(
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(21.0)),
          color: Colors.transparent,
          image:DecorationImage(image: NetworkImage("https://s3-ap-southeast-1.amazonaws.com/traveloka/imageResource/2019/05/14/1557849252505-39f98536afc07a3ebfe7812dbdc3ffd2.jpeg"),fit: BoxFit.cover),
          boxShadow: [BoxShadow(spreadRadius: -4, blurRadius: 5,color: Colors.black26,offset: Offset(0, 0))]
      ),
      padding: EdgeInsets.all(1),
      height: height,
      child: Material(
        color: Colors.transparent,
        borderRadius:BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onLongPress: (){},
          onTap: (){},
          child: Stack(
            children: <Widget>[
              Align(
                alignment:Alignment.bottomCenter ,
                child: Container(
                    decoration: new BoxDecoration(
                      color: Color.fromARGB(140,0, 0, 0),
                      borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(21))
                    ),
                    height: height * 0.45,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 21,vertical: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(0),),
                        Text("Bandung Saver",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                        Padding(padding: EdgeInsets.all(3),),
                        buildProgressBar(width)
                      ],
                    ),
                  ),
                ),
            ],
          )
        ),
      ),
    );
  }
  
  Widget buildProgressBar(width){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Rp. 250.000",style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.bold),),
            Text("Rp. 500.000",style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.bold),)
          ],
        ),
        Padding(padding: EdgeInsets.all(5),),
        LinearProgressIndicator(
          
          backgroundColor: Colors.white30,
          valueColor: AlwaysStoppedAnimation<Color>(DpColors.primary),
          value: 0.5,
        ),
      ],
    );
  }
}
