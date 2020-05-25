import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:dream_planner/ui/colors.dart';
import 'package:dream_planner/ui/pages/saver/saver_screen.dart';
import 'package:dream_planner/ui/pages/todo/todo_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
     
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            TodoScreen(),
            SaverScreen(),
            Container(child: Center(child: Icon(Icons.calendar_today),),),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text('Todo List'),
            activeColor: DpColors.primaryDark,
            inactiveColor: DpColors.primaryDark,
            icon: Icon(Icons.assignment_turned_in)
          ),
          BottomNavyBarItem(
              activeColor: DpColors.primaryDark,
              // inactiveColor: DpColors.primary,
              title: Text('Saver'),
              icon: Icon(Icons.account_balance_wallet)
          ),

          BottomNavyBarItem(
            activeColor: DpColors.primaryDark,
            // inactiveColor: DpColors.primary,
            title: Text('Calendar'),
            icon: Icon(Icons.calendar_today)
          ),

        ],
      ),
    );
  }
}