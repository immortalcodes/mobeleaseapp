import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobelease/screens/Admin/AssigningPage.dart';
import 'package:mobelease/ui_sizes.dart';
import 'package:mobelease/widgets/buttons.dart';
import '../../controllers/auth_controller.dart';
import '../../globals.dart';
import 'package:http/http.dart' as http;
import '../../models/Employee_Model.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/AssignCardMain.dart';
import '../../widgets/BottomAppBar.dart';
import '../../widgets/categories.dart';

class Assign extends StatefulWidget {
  final int id;
  EmployeeModel? employee;
  Assign({super.key, required this.id, this.employee});

  @override
  State<Assign> createState() => _AssignState();
}

class _AssignState extends State<Assign> {
  final AuthController authController = AuthController();

  ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> deviceQuantities = [];
  String selectedCategory = '';
  List<String> categoryKeys = [];
  Map<String, dynamic> devicesFuture = {};
  int totalPrice = 0;
  List<dynamic> items = [];
  int quantity = 0;

  Future<Map<String, dynamic>> fetchItemsFromApi() async {
    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/inv/viewassign');
    final response = await http.post(
      url,
      body: jsonEncode({"empid": widget.id}),
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      items = data['devices'].toList();
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

      totalPrice = items.fold<int>(0, (sum, item) {
        final int quantity = item['quantity'];
        final int cost = int.parse(item['cost']);
        return sum + (quantity * cost);
      });

      deviceQuantities = items.map((item) {
        return {
          'deviceid': item['deviceid'],
          'quantity': item['quantity'],
        };
      }).toList();

      print("DSU $deviceQuantities");
      // Store the device IDs with quantities in local storage

      return devicesFuture;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<void> addDevicetoAssign(int deviceId) async {
    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/inv/assign');

    final response = await http.post(
      url,
      body: jsonEncode({
        'empid': widget.id,
        'devices': [
          {'deviceid': deviceId, 'quantity': 1}
        ]
      }),
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      print("device added successfully");
      setState(() {});
    } else {
      print("failed to add devices");
    }
  }

  Future<void> addOrremoveDevice(
      List<Map<String, dynamic>> newdeviceQuantities) async {
    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/inv/editassign');

    final response = await http.post(
      url,
      body: jsonEncode({'empid': widget.id, 'devices': newdeviceQuantities}),
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      print("edited successfully");
    } else {
      print("failed to edit devices");
    }
  }

  void updateDeviceQuantity(int deviceId, int newQuantity) {
    final index =
        deviceQuantities.indexWhere((item) => item['deviceid'] == deviceId);
    if (index != -1) {
      deviceQuantities[index]['quantity'] = newQuantity;
    } else {
      deviceQuantities.add({'deviceid': deviceId, 'quantity': newQuantity});
    }
    print(deviceQuantities);
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
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: UiSizes(context: context).width_8, vertical: UiSizes(context: context).height_8),
        child: FutureBuilder(
            future: fetchItemsFromApi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Placeholder for loading state
              } else if (snapshot.hasError) {
                return AutoSizeText('Error: ${snapshot.error}');
              } else {
                Map<String, dynamic> categorizedDevices = snapshot.data!;
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: UiSizes(context: context).width_18),
                    child: Column(
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(top: UiSizes(context: context).height_11),
                          child: Appbar(),
                        ),
                        Padding(
                          padding:
                               EdgeInsets.only(top: UiSizes(context: context).height_23, bottom: UiSizes(context: context).height_16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                  "Assign to ${widget.employee!.firstName ?? " "} ",
                                  style: TextStyle(
                                      color: Color(0xffE96E2B),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.0)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AssigningPage(
                                            empId: widget.id,
                                            addorremoveFunction:
                                                addDevicetoAssign,
                                            deviceItems: items)),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 12.0,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.add_circle,
                                    color: Color(0xffE96E2B),
                                  ),
                                ),
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
                                padding:  EdgeInsets.symmetric(horizontal: UiSizes(context: context).width_6, vertical: UiSizes(context: context).height_6),
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: categorizedDevices[selectedCategory]
                                      ?.length ??
                                  0,
                              itemBuilder: (BuildContext context, int index) {
                                final device = categorizedDevices[
                                    selectedCategory]![index];

                                quantity = device['quantity'];

                                print("quantyr  $quantity");

                                return Padding(
                                  padding:
                                       EdgeInsets.symmetric(vertical: UiSizes(context: context).height_4),
                                  child: AssignCardMain(
                                      company: device['company'],
                                      cost: device['cost'],
                                      totalPrice: totalPrice,
                                      empId: widget.id,
                                      model: device['Name'],
                                      updateDeviceQuantity:
                                          updateDeviceQuantity,
                                      deviceId: device['deviceid'],
                                      quantity: quantity),
                                );
                              },
                            ),
                          ),
                        ),
                        Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: UiSizes(context: context).width_10, bottom: UiSizes(context: context).height_10, top: UiSizes(context: context).height_10),
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: double.infinity,
                                color: Colors.white,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(
                                      horizontal: UiSizes(context: context).height_11),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AutoSizeText("Total Price",
                                              style: TextStyle(
                                                  color: Color(0xff474747),
                                                  fontSize: 15.0)),
                                          AutoSizeText("\$ $totalPrice",
                                              style: TextStyle(
                                                  color: Color(0xffE96E2B),
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                      BlackButton(
                                          buttonText: "Assign",
                                          Width: UiSizes(context: context).width_106,
                                          Height: UiSizes(context: context).height_29,
                                          Radius: 13,
                                          onpress: () async {
                                            await addOrremoveDevice(
                                                deviceQuantities);
                                            setState(() {});
                                          }).buildBlackButton()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
      bottomNavigationBar: bottomAppBar(index: 1),
    );
  }
}
