import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobelease/screens/Admin/Employee.dart';
import '../../controllers/auth_controller.dart';
import '../../globals.dart';
import '../../models/Employee_Model.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/BottomAppBar.dart';
import '../../widgets/TextFieldWidget.dart';
import '../../widgets/TextFieldWidget2.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:http/http.dart' as http;

import 'Assign.dart';

class EditEmployee extends StatefulWidget {
  final int id;

  const EditEmployee({super.key, required this.id});

  @override
  State<EditEmployee> createState() => _EmployeePersonalState();
}
String? firstName =" ";
String? lastName = " ";
String? phoneNo = " ";
String? email = " ";
// final empPhoto = employee.empPhoto;
EmployeeModel employee = EmployeeModel();
class _EmployeePersonalState extends State<EditEmployee> {
  // EmployeeModel employee = EmployeeModel();
  EmployeeModel employee = EmployeeModel();

  final AuthController authController = AuthController();
  Future<EmployeeModel> getEmployee() async {
    print(widget.id);
    // int ids = widget.id + 1;
    final token = await authController.getToken();
    var url = Uri.https(baseUrl, '/emp/singleemployee');
    final client = http.Client();
    try {
      final response = await client.post(
        url,
        body: jsonEncode({"empid": widget.id}),
        headers: {'Cookie': token!, 'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        // print(response.body);
        final Map<String, dynamic> responseData = jsonDecode(response.body)!['data'!];
        final List<String> sortedKeys1 = responseData.keys!.toList();
        List<int> sortedKeys =  sortedKeys1.map((str) => int.parse(str!)).toList() ..sort();
        // print(sortedKeys);
        final List<EmployeeModel> employees = sortedKeys
            .map((key) => EmployeeModel.fromJson(responseData[key.toString()]))
            .toList();

        // setState(() {
          //   employee = employees.first;
          //   firstName = employee.firstName ?? " ";
          //   lastName = employee.lastName ?? " ";
          //   phoneNo = employee.phoneNo ?? " ";
          //   email = employee.email ?? " ";
          //   // print(employee.firstName);
          // });
        employee = employees.first;
        return employee;

      } else {
        throw Exception('Failed to load employees');
      }

      // return employees;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _firstnameController =
      TextEditingController(text: firstName);
  TextEditingController _lastnameController =
      TextEditingController(text: lastName);
  TextEditingController _phoneController =
      TextEditingController(text: phoneNo);
  TextEditingController _emailController =
      TextEditingController(text: email);
  TextEditingController _passwordController =
      TextEditingController();
  XFile? _imageFile;

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }

  void _submitForm( ) async {
    if (_formKey.currentState!.validate()) {
      final token = await authController.getToken();
      var url = Uri.https(baseUrl, '/emp/editemployee');
      final int empid = widget.id;
      final String firstname = _firstnameController.text;
      final String lastname = _lastnameController.text;
      final String phoneno = _phoneController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;
      // final encodedImage;
      if (_imageFile != null) {
        final imageBytes = await _imageFile!.readAsBytes();
        final encodedImage = base64Encode(imageBytes);
        print(encodedImage);
        final client = http.Client();
        try {
          final response = await client.post(
            url,
            body: jsonEncode({
              "empid": empid,
              "firstname": firstname,
              "lastname": lastname,
              "phoneno": phoneno,
              "email": email,
              "password": password,
              "employeephoto": encodedImage
            }),
            headers: {'Cookie': token!, 'Content-Type': 'application/json'},
          );
          if (response.statusCode == 200) {
            print('Form submitted successfully');
            _firstnameController.clear();
            _lastnameController.clear();
            _phoneController.clear();
            _emailController.clear();
            _passwordController.clear();
            setState(() {
              _imageFile = null;
            });
          } else {
            print(
                'Form submission failed with status code ${response.statusCode}');
          }
          // return employees;
        } catch (e) {
          return Future.error(e.toString());
        }
      }
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getEmployee();
  // }

  @override
  Widget build(BuildContext context) {
    // String name = employee.firstName ?? "name not available";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: FutureBuilder(
          future: getEmployee(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Placeholder for loading state
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            else{
              EmployeeModel employee = snapshot.data!;
              return  Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 11.0, left: 11.0, right: 11.0),
                    child: Appbar(),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 49.5,
                          backgroundImage: AssetImage('assets/images/image1.jpg'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 25,
                                ),
                                Text(
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
                                    Text(
                                      employee.phoneNo ?? " ",
                                      style: TextStyle(
                                          color: Color(0xffE96E2B),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Text(
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.08,
                        ),
                        Column(
                          children: [
                            IconButton(
                                onPressed: () {},
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
                        padding:
                        const EdgeInsets.symmetric(horizontal: 17.0, vertical: 8),
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            padding: EdgeInsets.all(8.0),
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width*0.42,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("First Name"),
                                        SizedBox(height: 5,),
                                        // TextEditingController()
                                        TextFieldWidget(
                                          controller: _firstnameController,
                                          hint: 'First Name',
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width*0.42,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Last Name"),
                                        SizedBox(height: 5,),
                                        TextFieldWidget(
                                          controller: _lastnameController,
                                          hint: 'Last Name',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Phone Number"),
                                  SizedBox(height: 5,),
                                  TextFieldWidget2(
                                    controller: _phoneController,
                                    hint:'Phone Number',
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("E-mail"),
                                  SizedBox(height: 5,),
                                  TextFieldWidget2(
                                    controller: _emailController,
                                    hint:"Email",
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Password"),
                                  SizedBox(height: 5,),
                                  TextFieldWidget2(
                                    controller: _passwordController,
                                    hint:"Password",
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Color(0xffE96E2B)),
                                onPressed: _getImage,
                                child: Text('Select Image'),
                              ),
                              _imageFile != null
                                  ? Image.file(
                                File(_imageFile!.path),
                                height: 150,
                                width: 150,
                              )
                                  : Container(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Color(0xffE96E2B)),
                                onPressed: _submitForm,
                                child: Text('Submit'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

          },
        )
      ),
      bottomNavigationBar: bottomAppBar(),
    );
  }
}
