import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mobelease/controllers/employee_controller.dart';
import 'package:mobelease/screens/Admin/EmployeePersonal.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../repository/employee_repository.dart';
import '../../models/Employee_Model.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/BottomAppBar.dart';
import '../../widgets/Employee_Icon.dart';
import 'package:mobelease/globals.dart';

import 'Assign.dart';

class EmployeeAll extends StatefulWidget {
  const EmployeeAll({super.key});

  @override
  State<EmployeeAll> createState() => _EmployeeAllState();
}

class _EmployeeAllState extends State<EmployeeAll> {
  List<EmployeeModel> employeesList = [];
  final AuthController authController = AuthController();
  Future<List<EmployeeModel>> getEmployee() async {
    final token = await authController.getToken();
    var url = Uri.https(baseUrl, '/emp/allemployee');
    final client = http.Client();
    try {
      final response = await client.post(
        url,
        headers: {'Cookie': token!, 'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            jsonDecode(response.body)!['data'!];
        final List<String> sortedKeys1 = responseData.keys!.toList();
        List<int> sortedKeys =
            sortedKeys1.map((str) => int.parse(str!)).toList()..sort();
        // print(sortedKeys);
        final List<EmployeeModel> employees = sortedKeys
            .map((key) => EmployeeModel.fromJson(responseData[key.toString()]))
            .toList();
        print(responseData.values);
        employeesList = employees;
        return employeesList;
        // if(mounted) {
        //   setState(() {
        //
        // });
        // }
      } else {
        throw Exception('Failed to load employees');
      }

      // return employees;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getEmployee();
  // }
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
            FutureBuilder(
                future: getEmployee(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Placeholder for loading state
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<EmployeeModel> employeesList = snapshot.data!;
                    return Expanded(
                      child: ListView.builder(
                          itemCount: employeesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final employee = employeesList[index];
                            final image;
                            if (employee.empPhoto != null) {
                              // image = base64Decode(employee.empPhoto??"assets/images/image1.jpg");
                            }
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
                                  leading: Employee_icon(
                                      imagePath: "assets/images/image1.jpg"),
                                  title: Text(
                                    employee.firstName ??
                                        'No First Name Available',
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
                    );
                  }
                }),
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBar(index: 0),
    );
  }
}
