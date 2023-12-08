import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobelease/screens/Admin/EditEmployee.dart';
import 'package:mobelease/ui_sizes.dart';
import '../../controllers/auth_controller.dart';
import '../../globals.dart';
import '../../models/Employee_Model.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/BottomAppBar.dart';

import 'package:http/http.dart' as http;

import 'Assign.dart';

class EmployeePersonal extends StatefulWidget {
  final int? empid;

  const EmployeePersonal({super.key, this.empid});

  @override
  State<EmployeePersonal> createState() => _EmployeePersonalState();
}

class _EmployeePersonalState extends State<EmployeePersonal> {
  late EmployeeModel employee = EmployeeModel();
  final AuthController authController = AuthController();

  Future<EmployeeModel> getEmployee() async {
    print("Id:  ${widget.empid}");

    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/emp/singleemployee');
    final client = http.Client();
    try {
      final response = await client.post(
        url,
        body: jsonEncode({"empid": widget.empid}),
        headers: {'Cookie': token!, 'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        // print(response.body);
        final Map<String, dynamic> responseData =
            jsonDecode(response.body)!['data'!];

        print("hello    $responseData");
        final List<String> sortedKeys1 = responseData.keys!.toList();
        List<int> sortedKeys =
            sortedKeys1.map((str) => int.parse(str!)).toList()..sort();
        // print(sortedKeys);
        final List<EmployeeModel> employees = sortedKeys
            .map((key) => EmployeeModel.fromJson(responseData[key.toString()]))
            .toList();
        employee = employees.first;
        print(employee.firstName);
        // setState(() {
        //   employee = employees.first;
        // });
        return employee;
      } else {
        throw Exception('Failed to load employees');
      }
      // return employees;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = employee.firstName ?? "name not available";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: FutureBuilder(
        future: getEmployee(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Placeholder for loading state
          } else if (snapshot.hasError) {
            return AutoSizeText('Error: ${snapshot.error}');
          } else {
            EmployeeModel employee = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: UiSizes(context: context).height_11,
                      left: UiSizes(context: context).width_11,
                      right: UiSizes(context: context).width_11),
                  child: Appbar(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: UiSizes(context: context).width_14,
                      vertical: UiSizes(context: context).height_18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      employee.empPhoto == null
                          ? CircleAvatar(
                              radius: 49.5,
                              backgroundImage: AssetImage(
                                  "assets/svgs/no-profile-picture.png"),
                            )
                          : CircleAvatar(
                              radius: 49.5,
                              backgroundImage: MemoryImage(
                                base64Decode(employee.empPhoto!),
                              ),
                            ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: UiSizes(context: context).height_25,
                                  ),
                                  AutoSizeText(
                                    employee.firstName ?? " ",
                                    style: TextStyle(
                                        color: Color(0xffE96E2B),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: Color(0xffE96E2B),
                                        size: 12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: AutoSizeText(
                                          employee.phoneNo ?? " ",
                                          style: TextStyle(
                                              color: Color(0xffE96E2B),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Assign(
                                        id: widget.empid!,
                                        employee: employee,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    AutoSizeText(
                                      "Assign Inventory",
                                      style: TextStyle(
                                          color: Color(0xffE96E2B),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Icon(
                                      Icons.arrow_right_alt,
                                      color: Color(0xffE96E2B),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.08,
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                size: 25.0,
                                color: Color(0xffE96E2B),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: UiSizes(context: context).width_17,
                            vertical: UiSizes(context: context).height_8),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: UiSizes(context: context).height_10,
                                  left: UiSizes(context: context).width_17,
                                  bottom: UiSizes(context: context).height_15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText("Details",
                                      style: TextStyle(
                                          color: Color(0xffE96E2B),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                  SizedBox(
                                    width: UiSizes(context: context).width_56,
                                    height: UiSizes(context: context).height_23,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditEmployee(
                                                id: widget.empid ?? 1,
                                                employeeData: employee),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.orange,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6))),
                                      child: AutoSizeText(
                                        "Edit",
                                        style: TextStyle(
                                            color: Color(0xffE96E2B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText("First Name"),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        height:
                                            UiSizes(context: context).height_44,
                                        margin: EdgeInsets.only(
                                            top: UiSizes(context: context)
                                                .height_8),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.43,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            border: Border.all(
                                              color: Color(0xffE96E2B),
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              Text(employee.firstName ?? " "),
                                        ))
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText("Last Name"),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        height:
                                            UiSizes(context: context).height_44,
                                        margin: EdgeInsets.only(
                                            top: UiSizes(context: context)
                                                .height_8),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.43,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            border: Border.all(
                                              color: Color(0xffE96E2B),
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: AutoSizeText(
                                              employee.lastName ?? " "),
                                        ))
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: UiSizes(context: context).height_15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText("Phone Number"),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    height: UiSizes(context: context).height_44,
                                    margin: EdgeInsets.only(
                                        top:
                                            UiSizes(context: context).height_8),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9),
                                        border: Border.all(
                                          color: Color(0xffE96E2B),
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          AutoSizeText(employee.phoneNo ?? " "),
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: UiSizes(context: context).height_15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText("Username or email address"),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    height: UiSizes(context: context).height_44,
                                    margin: EdgeInsets.only(
                                        top:
                                            UiSizes(context: context).height_8),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9),
                                        border: Border.all(
                                          color: Color(0xffE96E2B),
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          AutoSizeText(employee.email ?? " "),
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: UiSizes(context: context).height_15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText("Password (more than 8 letters)"),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    height: UiSizes(context: context).height_44,
                                    margin: EdgeInsets.only(
                                        top:
                                            UiSizes(context: context).height_8),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9),
                                        border: Border.all(
                                          color: Color(0xffE96E2B),
                                        )),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: UiSizes(context: context)
                                              .height_8,
                                          horizontal: UiSizes(context: context)
                                              .width_8),
                                      child: AutoSizeText("Password"),
                                    ))
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            );
          }
        },
      )),
      bottomNavigationBar: bottomAppBar(index: 0),
    );
  }
}
