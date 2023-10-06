import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../globals.dart';
import '../../widgets/Dropdown.dart';
import '../../widgets/TextFieldWidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddDeviceDialog extends StatefulWidget {
  final VoidCallback? onDeviceAdded;
  const AddDeviceDialog({super.key, this.onDeviceAdded});

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController authController = AuthController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _deviceNameController = TextEditingController();
  TextEditingController _costPriceController = TextEditingController();
  TextEditingController _storageController = TextEditingController();
  TextEditingController _remarkController = TextEditingController();
  String selectedValue =
      'watch'; // Define a variable to hold the selected value

  void updateSelectedValue(String value) {
    setState(() {
      selectedValue = value;
    });
  }

  void handleSubmit() async {
    final token = await authController.getToken();
    print(token);
    var url = Uri.parse('$baseUrl/inv/additem');
    final client = http.Client();
    print(selectedValue);
    var response = await http.post(
      url,
      body: jsonEncode({
        "itemtype": selectedValue,
        "company": _companyController.text,
        "devicedetail": _deviceNameController.text,
        "cost": _costPriceController.text,
        "storage": _storageController.text,
        "remark": _remarkController.text
      }),
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );

    // Check the response status
    if (response.statusCode == 200) {
      print('Form submitted successfully');
      _categoryController.clear();
      _companyController.clear();
      _deviceNameController.clear();
      _costPriceController.clear();
      _storageController.clear();
      _remarkController.clear();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Form submitted successfully"),
        duration: Duration(seconds: 5),
      ));
      widget.onDeviceAdded?.call();
    } else {
      print('Form submission failed with status code ${response.statusCode}');
    }
  }

  @override
  AlertDialog build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Add a new device",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xffE96E2B)),
          ),
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
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Category"),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(9)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyDropdown(
                              selectedValue: selectedValue,
                              onValueChanged: updateSelectedValue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Company"),
                      SizedBox(
                        height: 5,
                      ),
                      TextFieldWidget(
                        profileField: false,
                        hint: '',
                        controller: _companyController,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Device Name"),
                      SizedBox(
                        height: 5,
                      ),
                      TextFieldWidget(
                        profileField: false,
                        hint: '',
                        controller: _deviceNameController,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Storage"),
                      SizedBox(
                        height: 8,
                      ),
                      TextFieldWidget(
                        profileField: false,
                        hint: '',
                        controller: _storageController,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cost Price"),
                      SizedBox(
                        height: 5,
                      ),
                      TextFieldWidget(
                        profileField: false,
                        hint: '',
                        controller: _costPriceController,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Remark"),
                      SizedBox(
                        height: 8,
                      ),
                      TextFieldWidget(
                        profileField: false,
                        hint: '',
                        controller: _remarkController,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffE96E2B),
            ),
            child: const Text(
              "YES ADD",
            ),
            onPressed: () {
              handleSubmit();
              Navigator.of(context).pop();
              // Use the selectedValue here
              print('Selected Value: $selectedValue');
              // ... rest of your code
            },
          ),
        ),
      ],
    );
  }
}
