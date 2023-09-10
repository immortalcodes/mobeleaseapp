import 'dart:convert';

import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../globals.dart';
import 'package:http/http.dart' as http;
import '../../models/Employee_Model.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/BottomAppBar.dart';
import '../../widgets/categories.dart';
import '../../widgets/AssignCard.dart';

class Assign extends StatefulWidget {
  final int id;
  Assign({super.key,required this.id});

  @override
  State<Assign> createState() => _AssignState();
}

class _AssignState extends State<Assign> {
  late EmployeeModel employee = EmployeeModel();
  final AuthController authController = AuthController();
  Future<void> getEmployee() async {
    print(widget.id);
    // int ids = widget.id+1;
    final token = await authController.getToken();
    var url = Uri.https(baseUrl, '/emp/singleemployee');
    final client = http.Client();
    try {
      final response = await client.post(
        url,
        body: jsonEncode({"empid":widget.id}),
        headers: {'Cookie': token!,'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> responseData = jsonDecode(response.body)['data'];
        print(response.statusCode);
        print(responseData.values);
        final List<EmployeeModel> employees = responseData.values
            .map((employeeData) => EmployeeModel.fromJson(employeeData))
            .toList();
        setState(() {
          employee = employees.first;
          // print(employee.firstName);
        });
      }
      else {
        throw Exception('Failed to load employees');
      }

      // return employees;
    }
    catch (e) {
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 11.0),
                child: Appbar(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 23.0,bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(employee.firstName?? " ", style: TextStyle(color: Color(0xffE96E2B), fontWeight: FontWeight.w600, fontSize: 20.0 )),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/Employee');
                      },
                      child: CircleAvatar(
                        radius: 12.0,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.close, color: Colors.black,),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Categories(title: "Mobile", svgpath:'assets/svgs/Mobile.svg', onpress: (){}).buildCategories(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Categories(title: "Audio", svgpath:'assets/svgs/mic.svg', onpress: (){}).buildCategories(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Categories(title: "Accessories", svgpath:'assets/svgs/Accessories.svg', onpress: (){}).buildCategories(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                          radius: 12.5,
                          backgroundColor: Color(0xffF6DDD0),
                          child: Icon(Icons.add, color: Color(0xffE96E2B))),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  children: [
                    for(var i=0;i<20;i++)
                      Padding(
                        padding: const EdgeInsets.symmetric( vertical: 5.0),
                        child: AssignCard(model: "Redmi 11i pro", cost: 4500),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomAppBar(),
    );
  }
}
