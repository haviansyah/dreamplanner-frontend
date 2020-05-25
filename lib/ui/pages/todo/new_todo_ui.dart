import 'package:dream_planner/ui/colors.dart';
import 'package:dream_planner/ui/text_style.dart';
import 'package:flutter/material.dart';

class NewTodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: DpColors.primaryDark),
          onPressed: () => Navigator.of(context).pop(),
        ), 
        title: new Text("Create New Todo",style: DpText.titleAppBar,),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 21,right: 21,top :13),
        child: ListView(
          children: <Widget>[
            MyTextFormField(
              hintText: 'Todo Name',
              isEmail: true,
            ),
            MyTextFormField(
              hintText: 'Todo Name',
              isEmail: true,
            ),
          ],
        )
      )
    );
  }
}

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onSaved;
  final bool isPassword;
  final bool isEmail;

  MyTextFormField({
    this.hintText,
    this.validator,
    this.onSaved,
    this.isPassword = false,
    this.isEmail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          hintText: hintText,
          contentPadding: EdgeInsets.all(15.0),  
          filled: true,
          fillColor: Colors.grey[200],
        ),
        obscureText: isPassword ? true : false,
        validator: validator,
        onSaved: onSaved,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      ),
    );
  }
}