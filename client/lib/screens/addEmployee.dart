import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import '../controllers/auth_controller.dart';
import '../globals.dart';
import '../widgets/Appbar.dart';
import '../widgets/BottomAppBar.dart';
import '../widgets/TextFieldWidget.dart';

class addEmployee extends StatefulWidget {
  @override
  _addEmployee createState() => _addEmployee();
}

class _addEmployee extends State<addEmployee> {
  final AuthController authController = AuthController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  XFile? _imageFile;

  Future<void> _getImage() async {

    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final token = await authController.getToken();
      var url = Uri.https(baseUrl, '/emp/createemployee');
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
            print('Form submission failed with status code ${response
                .statusCode}');
          }
          // return employees;
        }
        catch (e) {
          return Future.error(e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 11.0,left: 11.0,right: 11.0),
              child: Appbar(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 23.0,bottom: 16.0,left: 18.0,right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Add Employee", style: TextStyle(color: Color(0xffE96E2B), fontWeight: FontWeight.w600, fontSize: 20.0 )),
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
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(14.0),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("First Name"),
                              SizedBox(height: 5,),
                              TextFieldWidget(
                                controller: _firstnameController,
                                hint: 'First Name',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.45,
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
                        TextFieldWidget(
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
                        TextFieldWidget(
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
                        TextFieldWidget(
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
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBar(),
    );
  }
}
