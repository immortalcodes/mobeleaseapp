import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:mobelease/models/Employee_Model.dart';
import 'package:mobelease/widgets/Appbar.dart';
import 'package:mobelease/widgets/Emp_bottomAppBar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ctbox extends StatefulWidget {
  ctbox({super.key});

  @override
  State<ctbox> createState() => _ctboxState();
}

class _ctboxState extends State<ctbox> {
  final TextEditingController _remarkController = TextEditingController();
  final AuthController authController = AuthController();
  List<Map<String, dynamic>> singleEmployeeList = [];

  Future<void> getSingleEmployee() async {
    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/emp/singleemployee');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? empId = prefs.getInt('empId');
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
    getSingleEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
                // mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 11.0, left: 11.0, right: 11.0, bottom: 5.0),
                    child: Appbar(),
                  ),
                ]),
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _remarkController,
                            decoration: InputDecoration(
                                hintText: "add a remark...",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () async {},
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.send_rounded,
                                color: Color(0xffE96E2B),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Emp_bottomAppBar(
        index: 3,
      ),
    );
  }
}
