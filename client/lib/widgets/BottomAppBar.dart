import 'package:flutter/material.dart';

class bottomAppBar extends StatefulWidget {
  const bottomAppBar({super.key});

  @override
  State<bottomAppBar> createState() => _bottomAppBarState();
}

class _bottomAppBarState extends State<bottomAppBar> {
  final PageController pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;
  Color _setColor = Colors.grey;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch(index){
      case 0:
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pushNamed(context, '/Employee');
        break;
      case 1:
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pushNamed(context, '/Inventory');
        break;
      case 2:
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pushNamed(context, '/EmployeeSelect');
        break;
      case 3:
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pushNamed(context, '/Remarks');
        break;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)),
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius:4),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_rounded),
                  label: "Employee"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_2_outlined),
                  label: "Inventory"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_outlined),
                  label: "Reports"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.recommend),
                  label: "Remarks"),
            ],
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xffE96E2B),
          onTap: _onItemTapped,
          elevation: 1.2,

        ),
      ),
    );
  }
}
