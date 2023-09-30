import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobelease/screens/Admin/EmployeePersonal.dart';
import '../../controllers/auth_controller.dart';
import '../../globals.dart';
import '../../models/Employee_Model.dart';
import '../../widgets/Employee_Icon.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/QuickStyle.dart';
import '../../widgets/BottomAppBar.dart';
import 'EmployeeAll.dart';
import '../../widgets/EmployeeDataCard.dart';
import 'package:http/http.dart' as http;

class Employee extends StatefulWidget {
  const Employee({Key? key}) : super(key: key);

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  List<EmployeeModel> employeesList = [];
  final AuthController authController = AuthController();

  Future<List<EmployeeModel>> getEmployee() async {
    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/emp/allemployee');
    final client = http.Client();
    try {
      final response = await client.post(
        url,
        headers: {'Cookie': token!, 'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            jsonDecode(response.body)!['data'];
        final List<String> sortedKeys1 = responseData.keys.toList();
        List<int> sortedKeys =
            sortedKeys1.map((str) => int.parse(str!)).toList();
        // print(sortedKeys);
        final List<EmployeeModel> employees = sortedKeys
            .map((key) => EmployeeModel.fromJson(responseData[key.toString()]))
            .toList();
        print('response data: $responseData');
        print("keys $sortedKeys");
        print(employees);
        employeesList = employees;
        // setState(() {});
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

  int employeeNo = 0;
  // List<String> items = [];
  // List<String> filteredItems = [];
  // @override
  // void initState() {
  //   super.initState();
  //   getEmployee();
  //   employeeNo = employeesList.length - 5;
  //   items = employeesList.map((employee) => employee.firstName ?? '').toList();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //
  //   // Call the reload method here
  //   widget.reload();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 11.0, left: 11.0, right: 11.0),
              child: Appbar(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Employees",
                        style: TextStyle(
                            color: Color(0xffE96E2B),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the desired page when clicked
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmployeeAll(),
                              ),
                            );
                          },
                          child: Text(
                            "See all",
                            style: TextStyle(
                              color: Color(0xffE96E2B),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                      )
                    ],
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
                        employeeNo = (employeesList.length > 6)
                            ? (employeesList.length - 5)
                            : 0;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 100,
                              width: 275,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: employeesList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    print('asdf $context, $index');
                                    final employee = employeesList[index];
                                    print('Employee Id:, ${employee.id}');
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // Navigate to the desired page when clicked
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (
                                                    context,
                                                  ) =>
                                                      EmployeePersonal(
                                                          empid: index + 1),
                                                ),
                                              );
                                            },
                                            child: Employee_icon(
                                                imagePath:
                                                    "assets/images/image1.jpg"),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                            width: 30.0,
                                            child: Text(
                                              employee.firstName ??
                                                  'No First Name Available',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 9.0),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            if (employeeNo != 0) ...[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigate to the desired page when clicked
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EmployeeAll(),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 24.5,
                                    backgroundColor:
                                        Color(0xffE96E2B).withOpacity(0.15),
                                    foregroundColor: Color(0xffE96E2B),
                                    child: Text(
                                      '+$employeeNo',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                            ]
                          ],
                        );
                      }
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 7.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Quick Actions",
                            style: TextStyle(
                                color: Color(0xffE96E2B),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '');
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "View all",
                                    style: TextStyle(
                                        color: Color(0xffE96E2B),
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.0),
                                  ),
                                  Icon(
                                    Icons.arrow_right_alt,
                                    color: Color(0xffE96E2B),
                                    weight: 10.0,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        QuickStyle(
                          title: "Assign Inventory",
                          svgPath: "assets/svgs/inventory.svg",
                          Context: '/EmployeeSelect',
                          colorhex: 0xffECFDF5,
                        ),
                        QuickStyle(
                            title: "Add employee",
                            svgPath: "assets/svgs/Addemployee.svg",
                            Context: '/addEmployee',
                            colorhex: 0xffFFF7ED),
                        QuickStyle(
                            title: "Credit Pending",
                            svgPath: "assets/svgs/Credit.svg",
                            Context: '',
                            colorhex: 0xffECFDF5),
                        QuickStyle(
                            title: "Add Devices",
                            svgPath: "assets/svgs/Adddevices.svg",
                            Context: '/AddDevice',
                            colorhex: 0xffEFF6FF),
                      ],
                    ),

                    // EmployeeDataCard(
                    //     cost: 4500,
                    //     date: '03/03/20232',
                    //     name: "Ashwin Jaiswal",
                    //     cash: true,
                    //     paid: true,
                    //     dues: false),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recent Selling",
                            style: TextStyle(
                                color: Color(0xffE96E2B),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBar(index: 0),
    );
  }
}
