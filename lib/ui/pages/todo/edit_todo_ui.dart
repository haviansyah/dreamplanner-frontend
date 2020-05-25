import 'dart:io';

import 'package:dream_planner/models/todo.dart';
import 'package:dream_planner/ui/colors.dart';
import 'package:dream_planner/ui/text_style.dart';
import 'package:dream_planner/ui/util/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as IOS;
import 'package:dream_planner/blocs/todo_edit_blocs.dart';
import 'package:intl/intl.dart';
import '../../mytextfield.dart';

class EditTodoScreen extends StatefulWidget {
  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  GlobalKey _keyRed = GlobalKey();
  final todoController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    todoController.text = editBloc.todo;
    return Scaffold(
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: (){
          editBloc.saveTodo();
          Navigator.of(context).pop();
        },
        backgroundColor: DpColors.primaryDark,
        elevation: 5.0,
        icon: Icon(Icons.save,color: Colors.white,),
        label: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: DpColors.primaryDark),
          onPressed: () => Navigator.of(context).pop(),
        ), 
        actions: <Widget>[
          new FlatButton(
          child: Text(""),
          onPressed: () => Navigator.of(context).pop(),
        ), 
        ],
        title: new Text("Edit Todo",style: DpText.titleAppBar,),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 21,right: 21,top :13),
        child: ListView(
          children: <Widget>[
            StreamBuilder<String>(
              stream: editBloc.todoStream,
              builder: (context, snapshot) {
                return MyTextFormField(
                  controller: todoController,
                  onChanged: editBloc.todoChangedStream,
                  hintText: 'Todo Name',
                );
              }
            ),
            StreamBuilder<bool>(
              stream: editBloc.isFinishedStream,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children : <Widget>[ 
                          Padding(
                            padding: const EdgeInsets.only(left : 13),
                            child: Text(
                              "Is Done "
                            ),
                          ),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children : <Widget>[
                              snapshot.data ?
                              StreamBuilder<DateTime>(
                                stream: editBloc.tanggalStream,
                                builder: (context, snapshot) {
                                  if(snapshot.hasData ){
                                    return IOS.GestureDetector(onTap:(){_selectDate(context);},child: Text(DateFormat("dd MMM yyyy").format(snapshot.data)));
                                  }
                                  return Container();
                                }
                              ) : Container(),
                              Checkbox(
                                value: snapshot.data, 
                                onChanged: (val){
                                  if(val) _selectDate(context);
                                  editBloc.isFinishedChangedStream(val);
                                } 
                              ),
                        ])
                        ]
                      ),
                      snapshot.data ? buildImagePicker() : Container()
                    ],
                  ); 
                }
                return Container();
              },
            ),
          ],
        )
      )
    );
  }

  Widget buildImagePicker(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: StreamBuilder<File>(
        stream: editBloc.imageFileStream,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return buildImagePreview(snapshot.data);
          }else{
            if(editBloc.image != null){
              return buildImagePreview(editBloc.image);
            }
            return addImageButton();
          }
        }
      ),
    );
  }
  Widget buildImagePreview(data){
    var size = MediaQuery.of(context).size.width - 68.0;
    return new Container(
      key: _keyRed,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        color: Colors.transparent,
        image: DecorationImage(image: data is String ? NetworkImage(data) : FileImage(data),fit: BoxFit.cover)
      ),
      padding: EdgeInsets.all(1),
      width: size,
      height: size,
      child: Material(
        color: Colors.transparent,
        borderRadius:BorderRadius.circular(12),
        child: InkWell(
          onTap: () async{        
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return CropImage();
            }));
          },
          borderRadius: BorderRadius.circular(12),
          child: Container()
        )
      )
    );
  }
  Widget addImageButton(){
    var size = MediaQuery.of(context).size.width - 68.0;
    return new Container(
      key: _keyRed,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        color: Colors.transparent,
      ),
      padding: EdgeInsets.all(1),
      width: size,
      height: size,
      child: Material(
        color: DpColors.primaryDark.withAlpha(150),
        borderRadius:BorderRadius.circular(12),
        child: InkWell(
          onTap: () async{        
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return CropImage();
            }));
          },
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.image,color: Colors.white,size: 55.0,),
                Text("Add Image",style: TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.bold),)
              ],
            ),
          ),
        )
      )
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: editBloc.tanggal?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != editBloc.tanggal){
      print(picked);
      editBloc.tanggalChangedStream(picked);
    }
  }
}

