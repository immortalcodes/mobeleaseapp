import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:mobelease/screens/Message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Emp_bottomAppBar extends StatefulWidget {
  final int index;
  const Emp_bottomAppBar({required this.index});

  @override
  State<Emp_bottomAppBar> createState() => _Emp_bottomAppBarState();
}

class _Emp_bottomAppBarState extends State<Emp_bottomAppBar> {
  final PageController pageController = PageController(initialPage: 0);

  int _selectedIndex = 0;
  final AuthController authController = AuthController();
  List<Map<String, dynamic>> singleEmployeeList = [];
  int? empId;

  Future<void> getSingleEmployee() async {
    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/emp/singleemployee');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    empId = prefs.getInt('empId');
    print(empId);
    final client = http.Client();
    try {
      final response = await client.post(
        url,
        body: jsonEncode({"empid": empId}),
        headers: {'Cookie': token!, 'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            jsonDecode(response.body)!['data'];
        singleEmployeeList =
            List<Map<String, dynamic>>.from(responseData.values);
      } else {
        throw Exception('Failed to load employees');
      }

      // return employees;
    } catch (e) {
      return print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex =
        widget.index; // Initialize _selectedIndex with the passed index
    getSingleEmployee();
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
          Navigator.pushReplacementNamed(context, '/Emp_home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/Emp_Inventory');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/Emp_Reports_1');
          break;
        case 3:
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Message(
                        empId: empId,
                        empImg: singleEmployeeList[0]['empphoto'],
                        empName:
                            "${singleEmployeeList[0]['firstname']} ${singleEmployeeList[0]['lastname']}",
                      )));
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
                    color:
                        _selectedIndex == 0 ? Color(0xffE96E2B) : Colors.grey),
                label: "Employee"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/svgs/inventory.svg",
                    color:
                        _selectedIndex == 1 ? Color(0xffE96E2B) : Colors.grey),
                label: "Inventory"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/svgs/Add.svg",
                    color:
                        _selectedIndex == 2 ? Color(0xffE96E2B) : Colors.grey),
                label: "Reports"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/svgs/Message.svg",
                    color:
                        _selectedIndex == 3 ? Color(0xffE96E2B) : Colors.grey),
                label: "Remarks"),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 1.2,
        ),
      ),
    );
  }
}
