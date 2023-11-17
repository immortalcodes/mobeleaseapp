import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class bottomAppBar extends StatefulWidget {
  final int index;
  const bottomAppBar({required this.index});

  @override
  State<bottomAppBar> createState() => _bottomAppBarState();
}

class _bottomAppBarState extends State<bottomAppBar> {
  final PageController pageController = PageController(initialPage: 0);

  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _selectedIndex =
        widget.index; // Initialize _selectedIndex with the passed index
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
          Navigator.pushReplacementNamed(context, '/report');
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
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 4),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/svgs/person.svg",
                    // ignore: deprecated_member_use
                    color:
                        _selectedIndex == 0 ? Color(0xffE96E2B) : Colors.grey),
                label: "Employee"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/svgs/inventory.svg",
                    // ignore: deprecated_member_use
                    color:
                        _selectedIndex == 1 ? Color(0xffE96E2B) : Colors.grey),
                label: "Inventory"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/svgs/Add.svg",
                    // ignore: deprecated_member_use
                    color:
                        _selectedIndex == 2 ? Color(0xffE96E2B) : Colors.grey),
                label: "Reports"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/svgs/Message.svg",
                    // ignore: deprecated_member_use
                    color:
                        _selectedIndex == 3 ? Color(0xffE96E2B) : Colors.grey),
                label: "Remarks"),
          ],
          selectedItemColor: Color(0xffE96E2B),
          unselectedLabelStyle: TextStyle(color: Colors.grey),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          useLegacyColorScheme: false,
          showUnselectedLabels: true,
          elevation: 1.2,
        ),
      ),
    );
  }
}
