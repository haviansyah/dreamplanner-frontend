import 'dart:io';

import 'package:dream_planner/ui/text_style.dart';
import 'package:flutter/material.dart';
import 'package:dream_planner/blocs/todo_edit_blocs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_image_crop/simple_image_crop.dart';
import '../colors.dart';

class CropImage extends StatelessWidget {
  final imgCropKey = GlobalKey<ImgCropState>();
  @override
  Widget build(BuildContext context) {
    try{
      ImagePicker.pickImage(source: ImageSource.gallery).then((File file){
        if(file == null){
          Navigator.of(context).pop();
        }
        editBloc.imageFileChangedStream(file);
      });
    }catch(e){
      Navigator.of(context).pop();
    }
    return Container(
      child: SafeArea(
          child: Stack(
          children: <Widget>[
            _buildCropImage(context),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 40,
              child: Container(
                child: _buildAppBar(context)
              )
            ),
            Positioned(
              bottom: 13,
              right: 13,
              child: FloatingActionButton.extended(
                backgroundColor: DpColors.primaryDark,
                onPressed: (){
                  _cropAndSave(context);
                }, 
                label: Text("Save",style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold),),
                elevation: 3.0, 
                icon: Icon(Icons.save,color: Colors.white),),
            )
          ],
        ),
      ),
    );
  }
  _buildAppBar(context){
    return AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text("Crop & Zoom Image", style: DpText.titleAppBarLight,),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: DpColors.primaryLight),
          onPressed: () => Navigator.of(context).pop(),
        ), 
      );
  }
  Widget _buildCropImage(context){
    final size = MediaQuery.of(context).size.width;
    return StreamBuilder<Object>(
      stream: editBloc.imageFileStream,
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data != null){
            return Container(
              child: ImgCrop.file(
                snapshot.data,
                key :  imgCropKey,
                chipRadius: size * 0.5, 
                chipShape: 'rect',
              ),
            );
        }else{
          return Container();
        }
      }
    );
  }

  _cropAndSave(context){
    if(editBloc.imageFile != null){
      final crop = imgCropKey.currentState;
      crop.cropCompleted(editBloc.imageFile,pictureQuality : 900).then((foto){
        editBloc.imageFileChangedStream(foto);
        Navigator.of(context).pop();
      });
    }
  }

}