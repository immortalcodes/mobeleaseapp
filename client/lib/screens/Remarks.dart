import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:mobelease/models/Employee_Model.dart';
import 'package:mobelease/screens/Admin/EmployeeSelect.dart';
import 'package:mobelease/screens/Message.dart';
import 'package:mobelease/widgets/RemarkCard.dart';
import '../widgets/Appbar.dart';
import '../widgets/BottomAppBar.dart';
import 'package:http/http.dart' as http;

class Remarks extends StatefulWidget {
  const Remarks({super.key});

  @override
  State<Remarks> createState() => _RemarksState();
}

class _RemarksState extends State<Remarks> {
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
      } else {
        throw Exception('Failed to load employees');
      }

      // return employees;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text("Remarks",
                      style: TextStyle(
                          color: Color(0xffE96E2B),
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0)),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.add_circle,
                      color: Color(0xffE96E2B),
                      size: 16.0,
                    ),
                  ),
                ],
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

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 5.0),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Message(
                                                empId: index + 1,
                                                empImg: employee.empPhoto ?? "",
                                                empName:
                                                    "${employee.firstName} ${employee.lastName}",
                                              )));
                                },
                                child: RemarkCard(
                                    imgpath: employee.empPhoto ?? "",
                                    name:
                                        "${employee.firstName} ${employee.lastName}",
                                    remark:
                                        'Wonderfull App!! Though Somechanges are required',
                                    time: '2 minn ago')),
                          );
                        }),
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBar(index: 3),
    );
  }
}
