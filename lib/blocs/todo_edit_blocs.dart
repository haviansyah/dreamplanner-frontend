import 'dart:convert';
import 'dart:io';

import 'package:dream_planner/models/todo.dart';
import 'package:dream_planner/repositories/todo_repositories.dart';
import 'package:rxdart/rxdart.dart';

class EditTodoBloc{
  final _repository = TodoRepository();
  final todoStreamController= BehaviorSubject<String>();
  final isFinishedStreamController = BehaviorSubject<bool>();
  final imageStreamController = BehaviorSubject<String>();
  final todoObjController = BehaviorSubject<Todo>();
  final tanggalStreamController = BehaviorSubject<DateTime>();
  final imageFileStreamController = BehaviorSubject<File>();

  Stream<String> get todoStream => todoStreamController.stream;
  Stream<bool> get isFinishedStream => isFinishedStreamController.stream;
  Stream<String> get imageStream => imageStreamController.stream;
  Stream<DateTime> get tanggalStream => tanggalStreamController.stream;
  Stream<File> get imageFileStream => imageFileStreamController.stream;

  bool get isFinished => isFinishedStreamController.value;
  String get todo => todoStreamController.value;
  Todo get todoObj => todoObjController.value;
  String get image => imageStreamController.value;
  DateTime get tanggal => tanggalStreamController.value;
  File get imageFile => imageFileStreamController.value;

  Function(String) get todoChangedStream => todoStreamController.sink.add; 
  Function(bool) get isFinishedChangedStream => isFinishedStreamController.sink.add; 
  Function(String) get imageChangedStream => imageStreamController.sink.add;
  Function(DateTime) get tanggalChangedStream => tanggalStreamController.sink.add;
  Function(File) get imageFileChangedStream => imageFileStreamController.sink.add;

  currentTodo(Todo todo){
    todoObjController.sink.add(todo);
    todoStreamController.sink.add(todo.todo);
    bool isFinished = todo.finishedAt != null;
    isFinishedStreamController.sink.add(isFinished);
    imageStreamController.sink.add(todo.image);
    tanggalStreamController.sink.add(todo.finishedAt);
    imageFileStreamController.sink.add(null);
  }

  Future<bool> saveTodo() async{
    Todo baru = this.todoObj;
    baru.todo = this.todo;
    baru.finishedAt = this.isFinished ? this.tanggal : null;
    String base64Image = this.imageFile != null ? base64Encode(this.imageFile.readAsBytesSync()) : null;
   
    try{
      await _repository.edit(baru,base64Image);
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }

  dispose(){
    todoStreamController.close();
    isFinishedStreamController.close();
    imageStreamController.close();
    todoObjController.close();
    imageFileStreamController.close();
    tanggalStreamController.close();
  }

}

final EditTodoBloc editBloc = new EditTodoBloc();