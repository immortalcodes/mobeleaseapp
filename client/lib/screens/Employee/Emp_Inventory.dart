import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:mobelease/widgets/AssignCard.dart';
import 'package:mobelease/widgets/categories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/Emp_bottomAppBar.dart';
import '../../widgets/buttons.dart';
import 'package:http/http.dart' as http;

class Emp_Inventory extends StatefulWidget {
  const Emp_Inventory({super.key});

  @override
  State<Emp_Inventory> createState() => _Emp_InventoryState();
}

class _Emp_InventoryState extends State<Emp_Inventory> {
  String selectedCategory = '';
  final AuthController authController = AuthController();
  Map<String, dynamic> devicesFuture = {};
  List<String> categoryKeys = [];

  List<dynamic> items = [];
  String? empId;

  Future<Map<String, dynamic>> fetchItemsFromApi() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    empId = prefs.getInt('empId').toString();

    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/inv/viewassign');
    final response = await http.post(
      url,
      body: jsonEncode({"empid": empId}),
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      items = data['devices'].toList();

      print("hdhdh $items");
      final Map<String, dynamic> categorizedItems = {};
      print("data: $data");
      print(categorizedItems.containsKey('watch'));
      for (var item in items) {
        print(item['ItemType']);

        if (categorizedItems.containsKey(item['ItemType'])) {
          categorizedItems[item['ItemType']]!.add(item);
        } else {
          categorizedItems[item['ItemType']] = [item];
        }
      }
      categoryKeys = categorizedItems.keys.toList();

      devicesFuture = categorizedItems;

      // Store the device IDs with quantities in local storage

      return devicesFuture;
    } else {
      throw Exception('Failed to load items');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchItemsFromApi().then((_) {
      print(categoryKeys);

      setState(() {
        selectedCategory = categoryKeys.isNotEmpty ? categoryKeys[0] : 'phone';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchItemsFromApi(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Placeholder for loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, dynamic> categorizedDevices = snapshot.data!;

            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 11.0, left: 11.0, right: 11.0),
                    child: Appbar(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 23.0, left: 18.0, right: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Categories",
                          style: TextStyle(
                              color: Color(0xffE96E2B),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: categorizedDevices.keys.map((category) {
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Categories(
                            title: category,
                            svgpath: "assets/svgs/Mobile.svg",
                            onpress: () {
                              setState(() {
                                selectedCategory =
                                    category; // Update the selected category
                              });
                            },
                            selectedCategory:
                                selectedCategory, // Pass selected category
                          ).buildCategories(),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          categorizedDevices[selectedCategory]?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        final device =
                            categorizedDevices[selectedCategory]![index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: AssignCard(
                            company: device['company'],
                            model: device['Name'],
                            quantity: device['quantity'].toString(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
      bottomNavigationBar: Emp_bottomAppBar(
        index: 1,
      ),
    );
  }
}
