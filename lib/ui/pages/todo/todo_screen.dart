import 'package:dream_planner/blocs/todo_blocs.dart';
import 'package:dream_planner/models/todo.dart';
import 'package:dream_planner/ui/colors.dart';
import 'package:dream_planner/ui/pages/todo/edit_todo_ui.dart';
import 'package:dream_planner/ui/pages/todo/todo_placeholder.dart';
import 'package:dream_planner/ui/text_style.dart';
import 'package:dream_planner/ui/util/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:dream_planner/blocs/todo_edit_blocs.dart';
import 'package:intl/intl.dart';


class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _newTextController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    
    // bloc.fetchAllTodo();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top:34,left:13,right:13),
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
                      padding: const EdgeInsets.symmetric(vertical:21),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          StreamBuilder(
                            stream: bloc.currentState,
                            builder:(BuildContext context, snapshot){
                              if(snapshot.hasData){
                                return Text(snapshot.data,style: DpText.title,);
                              }
                              return Text("",style: DpText.title,);
                            }  ,
                          ),
                          
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 21),
                            child : filterButton()
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              buildText(),
              StreamBuilder(
                  stream: bloc.allTodo,
                  initialData: TodoLoadingState,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.data is TodoDataState) {
                      var todoList = snapshot.data.todoCollection.todoList;
                      if (todoList.length > 0)
                        return buildGrid(todoList);
                      else
                        return buildEmpty();
                    }
                    if(snapshot.data is TodoLoadingState) {
                      return TodoPlaceHolder();
                    }

                    if(snapshot.hasError){
                      return buildError();
                    }
                    return TodoPlaceHolder();
                  }),
            ],
          ),
        ),
      )
    );
  }

  Padding buildText() {
    return Padding(
      padding: EdgeInsets.only(top:0,left:8,right:8),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(10, 0, 0, 0),
          borderRadius: BorderRadius.circular(12)
        ),
        padding: EdgeInsets.symmetric(horizontal: 21,vertical: 0),
        child: TextField(
          controller: _newTextController,
          onEditingComplete: editingCompleted,
          autofocus: false,
          decoration: InputDecoration(
            icon: Icon(Icons.add, color: Colors.black45),
            border: InputBorder.none,
            hintText: "New Todo",
            hintStyle: DpText.body
          ),
          autocorrect: false,
          style: TextStyle(fontSize: 13),
        ),
      ),
    );
  }

  void editingCompleted() async{
    var newTodo = _newTextController.text.toString();
    _newTextController.text = "";
    bloc.insertTodo(newTodo);
  }

  Expanded buildEmpty() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.sentiment_dissatisfied,size: (34.0+55.0),color: DpColors.primaryDark,),
            Padding(padding: EdgeInsets.all(8),),
            Text("Empty Here",style: DpText.title ,)
          ],
        )
        ),
      );
  }

  Expanded buildError() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.sentiment_dissatisfied,size: (34.0+55.0),color: DpColors.primaryDark,),
            Padding(padding: EdgeInsets.all(8),),
            Text("Can't Connecting To Server",style: DpText.title ,),
            Padding(padding: EdgeInsets.all(3),),
            Text("Check your internet connection",style: DpText.body,),
            Padding(padding: EdgeInsets.all(8),),
            GestureDetector(
              onTap: (){
                bloc.fetchAllTodo();
              },
              child: Text("Reload",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blueAccent),))
          ],
        )
      ),
    );
  }
  Expanded buildGrid(List<Todo> todoList) {
    return new Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new StaggeredGridView.countBuilder(
          scrollDirection: Axis.vertical,
          crossAxisCount: 2,
          itemCount: todoList.length,
          itemBuilder: (BuildContext context, int index) => buildCardTodo(todoList[index]),
          staggeredTileBuilder: (int index){
            var todo = todoList[index].todo;
            int max = todoList[0].todo.length;
            todoList.forEach((f){
              int leng = f.todo.length;
              if(leng > max) max = leng;
            }); 
            int length = todo.length;
            int rumus = ((length/(20)*4)).floor();
            return new StaggeredTile.count(1,1);
          },
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
      ),
    );
  }

  Container buildCardTodo(Todo todo) {
    return new Container(
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      color: Colors.transparent,
      image: todo.image != null ? DecorationImage(image: NetworkImage(todo.image),fit: BoxFit.cover) : null,
      boxShadow: [BoxShadow(spreadRadius: -4, blurRadius: 5,color: Colors.black26,offset: Offset(0, 0))]
    ),
    padding: EdgeInsets.all(1),
    height: 80,
    child: Material(
      color: todo.image != null ? Colors.black45 : Colors.white,
      borderRadius:BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: (){
          showDialog(context: context,builder:(context){
            return AlertDialog(
              title: Text("Are you sure want to delete this todo?"),
              actions: <Widget>[
                FlatButton(
                  onPressed: (){
                    bloc.deleteTodo(todo);
                    Navigator.of(context).pop();
                  },
                  child: Text("Yes"),),
                FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),),
              ],
            );
          } );
          // bloc.checkTodo(todo);
        },
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            editBloc.currentTodo(todo);
            return EditTodoScreen();
          }));
          // var todoBaru = todo;
          // todoBaru.finishedAt = todo.finishedAt != null ? null : DateTime.now();
          // bloc.checkTodo(todoBaru);
        },
        child: Stack(
          children: <Widget>[
              todo.finishedAt == null ? Container():buildChecked(),
              todo.finishedAt == null ? 
              new Center(
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 68) / 2 - 5,
                    child: new Text(todo.todo,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: todo.image != null ? Colors.white : Colors.black87),textAlign: TextAlign.center,)),
                )
                :
              new Positioned(
                bottom: 20,
                left: 8,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 68) / 2 - 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(todo.todo,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: todo.image != null ? Colors.white : Colors.black87),),
                      new Padding(padding: EdgeInsets.only(top:5)),
                      new Text(DateFormat('dd MMM yyyy').format(todo.finishedAt),style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: todo.image != null ? Colors.white : Colors.black87),),
                    ],
                  ),
                )
              )
            ]
          ),
        ),
      ),
    );
  }

  Widget filterButton(){
    return PopupMenuButton<int>(
        onSelected: (int val){
          bloc.filterTodo(val);
        },  
        child: Icon(Icons.filter_list,size: 21,color: DpColors.primaryDark,),
        itemBuilder:  (BuildContext context) => <PopupMenuEntry<int>>[
          const PopupMenuItem<int>(
            value: 0,
            child: Text('All'),
          ),
          const PopupMenuItem<int>(
            value: 1,
            child: Text('Finished Todo'),
          ),
          const PopupMenuItem<int>(
            value: 2,
            child: Text('Active Todo'),
          ),
        ]
    );
  }
  Positioned buildChecked() {
    return Positioned(
      right: 5,
      top: 5,
      child: new Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.greenAccent
        ),
        height: 20,
        width: 20,
        child: Icon(Icons.check,size: 15,),
      ), 
    );
  }
}

