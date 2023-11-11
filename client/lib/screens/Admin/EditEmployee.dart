import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/auth_controller.dart';
import '../../globals.dart';
import '../../models/Employee_Model.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/BottomAppBar.dart';
import '../../widgets/TextFieldWidget2.dart';
import 'package:http/http.dart' as http;

class EditEmployee extends StatefulWidget {
  final int id;
  final EmployeeModel employeeData;

  const EditEmployee({super.key, required this.id, required this.employeeData});

  @override
  State<EditEmployee> createState() => _EmployeePersonalState();
}

EmployeeModel employee = EmployeeModel();

class _EmployeePersonalState extends State<EditEmployee> {
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
      String? encodedImage;
      var url = Uri.parse('$baseUrl/emp/editemployee');
      final int empid = widget.id;
      final String firstname = _firstnameController.text;
      // ignore: unnecessary_null_comparison

      final String lastname = _lastnameController.text;
      final String phoneno = _phoneController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;
      print(password);
      print(lastname);

      if (_imageFile != null) {
        final imageBytes = await _imageFile!.readAsBytes();
        encodedImage = base64Encode(imageBytes);
        print(encodedImage);
      }
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Form Edited successfully"),
            duration: Duration(seconds: 5),
          ));
          print('Form submitted successfully');
          _firstnameController.clear();
          _lastnameController.clear();
          _phoneController.clear();
          _emailController.clear();
          _passwordController.clear();
          setState(() {
            _imageFile = null;
          });

          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Form submission failed"),
            duration: Duration(seconds: 5),
          ));
          print(
              'Form submission failed with status code ${response.statusCode}');
        }
        // return employees;
      } catch (e) {
        return Future.error(e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize controllers with data from widget
    _firstnameController.text = widget.employeeData.firstName ?? '';
    _lastnameController.text = widget.employeeData.lastName ?? '';
    _phoneController.text = widget.employeeData.phoneNo ?? '';
    _emailController.text = widget.employeeData.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // String name = employee.firstName ?? "name not available";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 11.0, left: 11.0, right: 11.0),
            child: Appbar(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.employeeData.empPhoto == null
                    ? CircleAvatar(
                        radius: 47.5,
                        backgroundImage:
                            AssetImage("assets/svgs/no-profile-picture.png"),
                      )
                    : CircleAvatar(
                        radius: 47.5,
                        backgroundImage: MemoryImage(
                          base64Decode(widget.employeeData.empPhoto!),
                        ),
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
                          "${widget.employeeData.firstName} ${widget.employeeData.lastName}",
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
                              child: Text(
                                "${widget.employeeData.phoneNo}",
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
                        Navigator.pushNamed(context, "/Assign");
                      },
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
                            width: MediaQuery.of(context).size.width * 0.42,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("First Name"),
                                SizedBox(
                                  height: 10,
                                ),
                                // TextEditingController()
                                SizedBox(
                                  height: 44,
                                  child: TextFieldWidget2(
                                    controller: _firstnameController,
                                    hint: widget.employeeData.firstName!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.42,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Last Name"),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 44,
                                  child: TextFieldWidget2(
                                    controller: _lastnameController,
                                    hint: widget.employeeData.lastName!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Phone Number"),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 44,
                            child: TextFieldWidget2(
                              controller: _phoneController,
                              hint: widget.employeeData.phoneNo!,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Username or email address"),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 44,
                            child: TextFieldWidget2(
                              controller: _emailController,
                              hint: widget.employeeData.email!,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Password (more than 8 letters)"),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 44,
                            child: TextFieldWidget2(
                              controller: _passwordController,
                              hint: "password",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Color(0xffE96E2B)),
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
                      SizedBox(
                        height: 8,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Color(0xffE96E2B)),
                        onPressed: _submitForm,
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
      bottomNavigationBar: bottomAppBar(index: 0),
    );
  }
}
