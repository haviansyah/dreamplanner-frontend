![Pub](https://img.shields.io/pub/v/bottom_navy_bar) <a href="https://github.com/Solido/awesome-flutter">
    <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>

# BottomNavyBar

A beautiful and animated bottom navigation. The navigation bar use your current theme, but you are free to customize it.

| Preview | PageView |
|---------|----------|
|![FanBottomNavyBar Gif](navy.gif "BottomNavyBar") | ![Fix Gif](fix.gif "Fix") |

## Customization (Optional)

### BottomNavyBar
- `iconSize` - the item icon's size
- `items` - navigation items, required more than one item and less than six
- `selectedIndex` - the current item index. Use this to change the selected item. Default to zero
- `onItemSelected` - required to listen when a item is tapped it provide the selected item's index
- `backgroundColor` - the navigation bar's background color
- `showElevation` - if false the appBar's elevation will be removed
- `mainAxisAlignment` - use this property to change the horizontal alignment of the items. It is mostly used when you have ony two items and you want to center the items
- `curve` - param to customize the item change's animation
 
### BottomNavyBarItem
- `icon` - the icon of this item
- `title` - the text that will appear next to the icon when this item is selected
- `activeColor` - the active item's background and text color
- `inactiveColor` - the inactive item's icon color
- `textAlign` - property to change the alignment of the item title

## Getting Started

Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  ...
  bottom_navy_bar: ^5.3.2
```

## Basic Usage

Adding the widget

```dart
bottomNavigationBar: BottomNavyBar(
   selectedIndex: _selectedIndex,
   showElevation: true, // use this to remove appBar's elevation
   onItemSelected: (index) => setState(() {
              _selectedIndex = index;
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
    }),
   items: [
     BottomNavyBarItem(
       icon: Icon(Icons.apps),
       title: Text('Home'),
       activeColor: Colors.red,
     ),
     BottomNavyBarItem(
         icon: Icon(Icons.people),
         title: Text('Users'),
         activeColor: Colors.purpleAccent
     ),
     BottomNavyBarItem(
         icon: Icon(Icons.message),
         title: Text('Messages'),
         activeColor: Colors.pink
     ),
     BottomNavyBarItem(
         icon: Icon(Icons.settings),
         title: Text('Settings'),
         activeColor: Colors.blue
     ),
   ],
)
```

## Use with PageView and PageController

```
class _MyHomePageState extends State<MyHomePage> {

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
      appBar: AppBar(title: Text("Nav Bar")),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(color: Colors.blueGrey,),
            Container(color: Colors.red,),
            Container(color: Colors.green,),
            Container(color: Colors.blue,),
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
            title: Text('Item One'),
            icon: Icon(Icons.home)
          ),
          BottomNavyBarItem(
            title: Text('Item One'),
            icon: Icon(Icons.apps)
          ),
          BottomNavyBarItem(
            title: Text('Item One'),
            icon: Icon(Icons.chat_bubble)
          ),
          BottomNavyBarItem(
            title: Text('Item One'),
            icon: Icon(Icons.settings)
          ),
        ],
      ),
    );
  }
}
```