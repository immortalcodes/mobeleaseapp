import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Emp_Dropdown_Unit extends StatefulWidget {
  List<String> farmunitList;
  String farmName;
  final Function(String) onSelectFarmUnit;
  Emp_Dropdown_Unit(
      {required this.farmunitList,
      required this.farmName,
      required this.onSelectFarmUnit});

  @override
  _Emp_Dropdown_UnitState createState() => _Emp_Dropdown_UnitState();
}

class _Emp_Dropdown_UnitState extends State<Emp_Dropdown_Unit> {
  @override
  void initState() {
    super.initState();
  }

  var dropdownvalue;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      underline: Container(),
      value: dropdownvalue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownvalue = newValue;
          widget.onSelectFarmUnit(newValue!);
        });
      },
      items: [
        if (widget.farmunitList.isNotEmpty)
          ...widget.farmunitList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Item(
                value: value,
                farmName: widget.farmName,
              ),
            );
          }),
        DropdownMenuItem<String>(
          value: 'Add New',
          child: Item(
            value: 'Add New',
            farmName: widget.farmName,
          ),
        ),
      ],
      icon: Icon(
        Icons.keyboard_arrow_down_sharp,
        color: Color(0xffE96E2B),
      ),
      isExpanded: true,
      elevation: 0,
      style: TextStyle(color: Colors.grey),
    );
  }
}

// ignore: must_be_immutable
class Item extends StatefulWidget {
  String value = '';
  String farmName;
  Item({super.key, required this.value, required this.farmName});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  TextEditingController _textFieldController = TextEditingController();

  Future<void> addNewFarmUnitApi(String farmUnit, String farmName) async {
    final AuthController authController = AuthController();

    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/sale/addfarmunit');
    final response = await http.post(
      url,
      body: jsonEncode({"farmname": farmName, "unitname": farmUnit}),
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print("Added farm unit succesfully");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Added farm Unit succesfully"),
        duration: Duration(seconds: 5),
      ));
    } else {
      throw Exception('Failed to add farm Unit!');
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Farm Unit'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Enter farm Unit name"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Add'),
              onPressed: () async {
                if (_textFieldController.text.isNotEmpty) {
                  print(_textFieldController.text);
                  await addNewFarmUnitApi(
                      _textFieldController.text, widget.farmName);

                  Navigator.of(context).pop();
                }
              },
            ),
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value == 'Add New') {
      return GestureDetector(
        onTap: _showDialog,
        child: Row(
          children: [
            Text(widget.value,
                style: TextStyle(color: Color(0xffE96E2B), fontSize: 14)),
            Icon(Icons.add, color: Color(0xffE96E2B), size: 14),
          ],
        ),
      );
    } else {
      return Text(widget.value); // You should return the Text widget here
    }
  }
}
