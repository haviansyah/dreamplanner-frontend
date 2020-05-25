import 'package:dream_planner/models/todo.dart';
import 'package:dream_planner/providers/todo_provides.dart';

class TodoRepository{
  final TodoProvider todoProvider = TodoProvider();

  Future<TodoCollection> fetchAllTodo() => todoProvider.fetchTodo();
  Future<void> newTodo(Todo todo) => todoProvider.newTodo(todo); 
  Future<void> deleteTodo(Todo todo) => todoProvider.deleteTodo(todo); 
  Future<void> edit(Todo todo, String image) => todoProvider.update2(todo : todo,image: image);

}