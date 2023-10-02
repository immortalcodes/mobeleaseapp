import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:mobelease/screens/Admin/EmployeePersonal.dart';

import '../../controllers/auth_controller.dart';

import '../../models/Employee_Model.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/BottomAppBar.dart';
import '../../widgets/Employee_Icon.dart';
import 'package:mobelease/globals.dart';

class EmployeeAll extends StatefulWidget {
  List<EmployeeModel>? employeeList;
  EmployeeAll({super.key, this.employeeList});

  @override
  State<EmployeeAll> createState() => _EmployeeAllState();
}

class _EmployeeAllState extends State<EmployeeAll> {
  final AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 11.0, left: 11.0, right: 11.0),
              child: Appbar(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 23.0, bottom: 16.0, left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("List of all Employees",
                      style: TextStyle(
                          color: Color(0xffE96E2B),
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 12.0,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 7.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xffE96E2B),
                  ),
                  hintText: "Search Employees",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9.0),
                    borderSide: BorderSide(color: Color(0xffE96E2B)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.employeeList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final employee = widget.employeeList![index];
                    final image;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EmployeePersonal(empid: index + 1),
                            ),
                          );
                        },
                        child: ListTile(
                          leading:
                              Employee_icon(imagePath: employee.empPhoto ?? ""),
                          title: Text(
                            employee.firstName ?? 'No First Name Available',
                          ),
                          trailing: Icon(
                            Icons.arrow_right,
                            color: Color(0xffE96E2B),
                          ),
                          tileColor: Colors.white,
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBar(index: 0),
    );
  }
}
