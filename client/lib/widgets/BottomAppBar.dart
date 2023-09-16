import 'package:flutter/material.dart';

class bottomAppBar extends StatefulWidget {
  final int index ;
  const bottomAppBar({required this.index});

  @override
  State<bottomAppBar> createState() => _bottomAppBarState();
}

class _bottomAppBarState extends State<bottomAppBar> {
  final PageController pageController = PageController(initialPage: 0);

  int _selectedIndex =0;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index; // Initialize _selectedIndex with the passed index
  }
  void _onItemTapped(int index) {
    // Check if the selected index is the same as the current index
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      // Perform navigation only if the index is different
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/Employee');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/Inventory');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/EmployeeSelect');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/Remarks');
          break;
      }
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
