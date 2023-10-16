import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:http/http.dart' as http;

class Emp_Dropdown_Farm extends StatefulWidget {
  final Function(List<String>, String) onSelectFarm;
  Emp_Dropdown_Farm({required this.onSelectFarm});

  @override
  _Emp_Dropdown_FarmState createState() => _Emp_Dropdown_FarmState();
}

class _Emp_Dropdown_FarmState extends State<Emp_Dropdown_Farm> {
  final AuthController authController = AuthController();
  List<String> farmList = [];
  List<String> farmUnitList = [];

  Future<void> viewFarmApi() async {
    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/sale/viewfarm');
    final response = await http.post(
      url,
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final dynamic fetchedData = data["data"];
      final List<List<String>> farms = fetchedData
          .map<List<String>>((item) => List<String>.from(item))
          .toList();

      List<String> flattenedFarmList =
          farms.expand((element) => element).toList();
      // print(farms);
      setState(() {
        farmList = flattenedFarmList;
      });
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<void> viewFarmUnitApi(String farmName) async {
    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/sale/viewfarmunit');
    final response = await http.post(
      url,
      body: jsonEncode({"farmname": farmName}),
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final dynamic fetchedData = data["data"];
      final List<List<String>> farmUnit = fetchedData
          .map<List<String>>((item) => List<String>.from(item))
          .toList();
      // print("farm unit $farmUnit");
      List<String> flattenedFarmList =
          farmUnit.expand((element) => element).toList();
      setState(() {
        farmUnitList = flattenedFarmList;
      });
    } else {
      throw Exception('Failed to load farm unit');
    }
  }

  void onAddFarm() async {
    await viewFarmApi();
    setState(() {
      dropdownvalue = farmList.last;
    });
    print(dropdownvalue);
  }

  @override
  void initState() {
    super.initState();
    viewFarmApi(); // Fetch data from the API when the widget is initialized
  }

  var dropdownvalue;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      underline: Container(),
      value: dropdownvalue,
      onChanged: (String? newValue) async {
        setState(() {
          dropdownvalue = newValue;
        });

        await viewFarmUnitApi(dropdownvalue);
        widget.onSelectFarm(farmUnitList, dropdownvalue);
        print("units: $farmUnitList");
        print(dropdownvalue);
      },
      items: [
        ...farmList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Item(
              value: value,
              onAddfn: onAddFarm,
            ),
          );
        }),
        DropdownMenuItem<String>(
          value: 'Add New',
          child: Item(
            value: "Add New",
            onAddfn: onAddFarm,
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

class Item extends StatefulWidget {
  String value = '';

  void onAddfn;
  Item({
    super.key,
    required this.value,
    required this.onAddfn,
  });

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  TextEditingController _textFieldController = TextEditingController();

  Future<void> addNewFarmApi(String farmName) async {
    final AuthController authController = AuthController();

    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/sale/addfarm');
    final response = await http.post(
      url,
      body: jsonEncode({"farmname": farmName}),
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print("Added farm succesfully");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Added farm succesfully"),
        duration: Duration(seconds: 5),
      ));
    } else {
      throw Exception('Failed to add farm!');
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Farm'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Enter farm name"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Add'),
              onPressed: () async {
                if (_textFieldController.text.isNotEmpty) {
                  print(_textFieldController.text);
                  await addNewFarmApi(_textFieldController.text);
                  setState(() {
                    widget.value = _textFieldController.text;
                  });
                  widget.onAddfn;

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
