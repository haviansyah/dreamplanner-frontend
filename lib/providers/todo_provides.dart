import 'dart:convert';

import 'package:dream_planner/models/todo.dart';
import 'package:dream_planner/providers/backend_config.dart';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TodoProvider{
  Client client = Client();
  final _urlTodo = "${Backend.url}/api/todos";
  final socket = IO.io("${Backend.url}",<String, dynamic>{'transports': ['websocket'],});

  Future<TodoCollection> fetchTodo() async{
    try{
      final response = await client.get(_urlTodo);
      if(response.statusCode == 200){
        return TodoCollection.fromMap(jsonDecode(response.body));
      }else{
        print(response);
        throw Exception("Failed to get bonus");
      }
    }catch(e){
      print(e);
      throw Exception("Failed to get bonus");
    }
  }

  Future<void> newTodo(Todo todo) async{
    return socket.emit("newTodo",todo.todo);

  }

  Future<void> deleteTodo(Todo todo) async{
    var id = todo.id;
    return socket.emit("deleteTodo",jsonEncode({"_id":id}));
  }

  Future<void> update(Todo todo) async{
    var id = todo.id;
    print(todo.toMap());
    return socket.emit("editTodo",jsonEncode({"_id":id,"edit":todo.toMap()}));
  }

  Future<void> update2({Todo todo,String image}) async{
    // try{
      final response = await client.post(_urlTodo,
        // headers: {"Content-Type": "application/json"},
        body: {...todo.toMap(), "image" : image != null ? image : ""}
        //  jsonEncode({"_id":todo.id,"edit":todo.toMap()})
      );
      if(response.statusCode == 200){
         return TodoCollection.fromMap(jsonDecode(response.body));
      }else{
         print(response);
         throw Exception("Failed to get bonus");
      }

  }
}