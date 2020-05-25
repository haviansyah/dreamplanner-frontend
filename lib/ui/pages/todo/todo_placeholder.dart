import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TodoPlaceHolder extends StatefulWidget {
  @override
  _TodoPlaceHolderState createState() => _TodoPlaceHolderState();
}

class _TodoPlaceHolderState extends State<TodoPlaceHolder> with SingleTickerProviderStateMixin {
   AnimationController _controller;

  Animation gradientPosition;
   @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 1500), vsync: this);

    gradientPosition = Tween<double>(
      begin: -3,
      end: 4,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear
      ),
    )..addListener(() {
      setState(() {});
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
          child: new StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: 4,
            itemBuilder: (context,index){
              return new Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment(gradientPosition.value, 0),
                    end: Alignment((gradientPosition.value+2), 0),
                    colors: [Colors.black87, Colors.black26, Colors.black87]
                  )
                ),
              );
            },
            staggeredTileBuilder: (index){
              return new StaggeredTile.count( 1, 1);
            },
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          )
    )
  );
  }
}