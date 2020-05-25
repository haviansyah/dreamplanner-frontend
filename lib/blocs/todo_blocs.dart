import 'package:dream_planner/models/todo.dart';
import 'package:dream_planner/providers/backend_config.dart';
import 'package:dream_planner/repositories/todo_repositories.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class TodoBlocs{
  final  status = ["Todo List","Finished Todo","Active Todo"];
  final _repository = TodoRepository();
  final _todoFetcher = BehaviorSubject<TodoState>();
  final _currentSelectedTodo = BehaviorSubject<Todo>();
  final _isLoading = BehaviorSubject<bool>();
  final _currentState = BehaviorSubject<String>();
  final socket = IO.io('${Backend.url}',<String, dynamic>{
    'transports': ['websocket'],
    });

  Stream<bool> get isLoading => _isLoading.stream;
  Stream<TodoState> get allTodo => _todoFetcher.stream;
  Stream<Todo> get currentSelectedTodo => _currentSelectedTodo.stream;
  Stream<String> get currentState => _currentState.stream;

  TodoBlocs(){
    _currentState.sink.add(status[0]);
    this.fetchAllTodo();
    socket.on("todoChange",newTodo);
  }

  newTodo(respData) async{
    fetchAllTodo();
  }

  Future<void> insertTodo(String text) async{
    await _repository.newTodo(new Todo(todo: text));
    return fetchAllTodo();
  }

  deleteTodo(Todo todo){
    _repository.deleteTodo(todo);
  }

  editTodo(Todo todo){
    _currentSelectedTodo.sink.add(todo);
  }

  fetchAllTodo() async{
    _todoFetcher.sink.add(TodoState._todoLoading());
    try{
      TodoCollection todoCollection = await _repository.fetchAllTodo();
      _todoFetcher.sink.add(TodoState._todoData(todoCollection));
    }catch(e){
      _todoFetcher.sink.addError(e);
    }
  }

  filterTodo(int type) async{
    _currentState.sink.add(status[type]);
    bool finish;
    switch(type){
      case 0 : return fetchAllTodo(); break;
      case 1 : finish = true; break;
      case 2 : finish = false; break;
    }
    _todoFetcher.sink.add(TodoState._todoLoading());
    TodoCollection todoCollection = await _repository.fetchAllTodo();
    var todoList = todoCollection.todoList;
    var filtered = todoList.where((i) => (i.finishedAt != null) == finish).toList();
    var todoBaru = new TodoCollection(filtered);
    _todoFetcher.sink.add(TodoState._todoData(todoBaru));

  }

  dispose(){
    _todoFetcher.close();
    _currentSelectedTodo.close();
    _isLoading.close();
    _currentState.close();
  }
}

class TodoState{
  TodoState();
  factory TodoState._todoLoading() = TodoLoadingState;
  factory TodoState._todoData(TodoCollection todoCollection) = TodoDataState;

}

class TodoLoadingState extends TodoState {}

class TodoDataState extends TodoState{
  final TodoCollection todoCollection;
  TodoDataState(this.todoCollection);
}

final bloc = TodoBlocs(); 