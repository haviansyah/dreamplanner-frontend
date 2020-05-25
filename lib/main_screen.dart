
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;


class MainScreen2 extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen2> {

  List<String> teks = List();
  @override
  void initState() {
    super.initState();

    http.get('http://localhost:3000/api/todos').then((value){
      List<dynamic> data = jsonDecode(value.body);
      data.forEach((dat){
        setState(() {
          teks.add(dat["todo"]);
        });
      });
    });

    IO.Socket socket = IO.io('http://localhost:3000',<String, dynamic>{
    'transports': ['websocket'],
    });

    socket.on("connect", (_){
      print("connected");
    });

    socket.on("new_saver",(data){
      setState(() {
        teks.add(data["name"]);
      });
    });

  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        child: Center(
          child: ListView.builder(
            itemCount: teks.length,
            itemBuilder: (context,int index){
              return ListTile(
                 title: Text(teks[index]),
              );
          })
        )
      )
    );
  }
}