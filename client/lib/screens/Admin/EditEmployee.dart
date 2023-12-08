import 'dart:io';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobelease/ui_sizes.dart';
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
      print(password + 'NONE');
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
          body: password == ''
              ? jsonEncode({
                  "empid": empid,
                  "firstname": firstname,
                  "lastname": lastname,
                  "phoneno": phoneno,
                  "email": email,
                  "employeephoto": encodedImage
                })
              : jsonEncode({
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
            padding: EdgeInsets.only(
                top: UiSizes(context: context).height_11,
                left: UiSizes(context: context).width_11,
                right: UiSizes(context: context).width_11),
            child: Appbar(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: UiSizes(context: context).width_14,
                vertical: UiSizes(context: context).height_12),
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
                          height: UiSizes(context: context).height_25,
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: UiSizes(context: context).width_6,
                                  vertical: UiSizes(context: context).height_6),
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
            height: UiSizes(context: context).height_15,
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
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: UiSizes(context: context).width_8, vertical: UiSizes(context: context).height_8),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.42,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText("First Name"),
                                SizedBox(
                                  height: UiSizes(context: context).height_10,
                                ),
                                // TextEditingController()
                                SizedBox(
                                  height: UiSizes(context: context).height_44,
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
                                AutoSizeText("Last Name"),
                                SizedBox(
                                  height: UiSizes(context: context).height_10,
                                ),
                                SizedBox(
                                  height: UiSizes(context: context).height_44,
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
                        height: UiSizes(context: context).height_18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText("Phone Number"),
                          SizedBox(
                            height: UiSizes(context: context).height_10,
                          ),
                          SizedBox(
                            height: UiSizes(context: context).height_44,
                            child: TextFieldWidget2(
                              controller: _phoneController,
                              hint: widget.employeeData.phoneNo!,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: UiSizes(context: context).height_18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText("Username or email address"),
                          SizedBox(
                            height: UiSizes(context: context).height_10,
                          ),
                          SizedBox(
                            height: UiSizes(context: context).height_44,
                            child: TextFieldWidget2(
                              controller: _emailController,
                              hint: widget.employeeData.email!,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: UiSizes(context: context).height_18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText("Password (more than 8 letters)"),
                          SizedBox(
                            height: UiSizes(context: context).height_10,
                          ),
                          SizedBox(
                            height: UiSizes(context: context).height_44,
                            child: TextFieldWidget2(
                              controller: _passwordController,
                              hint: "password",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: UiSizes(context: context).height_18,
                      ),
                      SizedBox(
                        height: UiSizes(context: context).height_10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Color(0xffE96E2B)),
                        onPressed: _getImage,
                        child: AutoSizeText('Select Image'),
                      ),
                      _imageFile != null
                          ? Image.file(
                              File(_imageFile!.path),
                              height: UiSizes(context: context).height_150,
                              width: UiSizes(context: context).width_150,
                            )
                          : Container(),
                      SizedBox(
                        height: UiSizes(context: context).height_8,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Color(0xffE96E2B)),
                        onPressed: _submitForm,
                        child: AutoSizeText('Save'),
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
