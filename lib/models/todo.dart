import 'dart:io';

import 'package:dream_planner/providers/backend_config.dart';
import 'package:intl/intl.dart';

class TodoCollection{
  List<Todo> _todoList = [];

  TodoCollection(this._todoList);

  TodoCollection.fromMap(List<dynamic> datas){
    List<Todo> _tempList = [];
    datas.forEach((data){
        Todo todo = Todo.fromMap(data);
        _tempList.add(todo);
    });
    _todoList = _tempList;
  }

  List<Todo> get todoList => _todoList;
}

class Todo {
  String id;
  String todo;
  DateTime finishedAt;
  String _image;


  Todo({this.id,this.todo,this.finishedAt});
  Todo.fromMap(Map<String,dynamic> data){
    this.id = data["_id"];
    this.todo = data["todo"];
    this.finishedAt = data["finishedAt"] != null ? DateTime.parse(data["finishedAt"]) : null;
    this._image = data["image"];
  }

  String get image => _image == null ? null : Backend.url+"/images/todo/"+_image;

  toMap(){
    return {
      "_id" : id,
      "todo" : todo,
      "finishedAt" : finishedAt == null ? "" : DateFormat("yyyy-MM-dd").format(finishedAt),
      "image" : image,
    };
  }
  String toString(){
    return '''{
      '_id' : ${id},
      'todo' : ${todo},
      'finishedAt' : ${finishedAt == null ? null : DateFormat("yyyy-MM-dd").format(finishedAt)},
      'image' : ${image},
    }''';
  }
}

class TodoImage{
  File file;
  String id;
  String address;
  bool isCover = false;

  TodoImage({this.id,this.address,this.isCover});

  Map<String,dynamic> toMap(){
    return {
      "_id" : id,
      "address" : address,
      "isCover" : isCover,
    };
  }
}