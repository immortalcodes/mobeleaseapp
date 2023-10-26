import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:mobelease/screens/Employee/Emp_Assign_2.dart';
import 'package:mobelease/widgets/AssignCard.dart';
import 'package:mobelease/widgets/categories.dart';
import 'package:provider/provider.dart';
import '../../widgets/Appbar.dart';
import 'package:http/http.dart' as http;

class Emp_Assign_1 extends StatefulWidget {
  int? empId;
  Emp_Assign_1({super.key, this.empId});

  @override
  State<Emp_Assign_1> createState() => _Emp_Assign_1State();
}

class _Emp_Assign_1State extends State<Emp_Assign_1> {
  String selectedCategory = '';
  final AuthController authController = AuthController();
  List<String> categoryKeys = [];
  TextEditingController searchController = TextEditingController();

  Map<String, dynamic> devicesFuture = {};
  Map<String, dynamic> searchedDevices = {};

  List<dynamic> items = [];
  // Set<Map<String, dynamic>> isSelectedItems = {};
  bool isSelected = false;
  Future<Map<String, dynamic>> fetchItemsFromApi() async {
    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/inv/viewassign');
    final response = await http.post(
      url,
      body: jsonEncode({"empid": widget.empId}),
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      items = data['devices'].toList();
      final Map<String, dynamic> categorizedItems = {};

      print("data: $data");
      print(categorizedItems.containsKey('watch'));

      final Map<int, dynamic> uniqueItemsMap = {};
      for (var item in items) {
        uniqueItemsMap[item['deviceid']] = item;
      }
      items = uniqueItemsMap.values.toList();
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

  void filterSearchResults(String query) {
    setState(() {
      searchedDevices = devicesFuture.map((key, value) => MapEntry(
          key,
          value
              .where((item) =>
                  item['company'].toLowerCase().contains(query.toLowerCase()) ||
                  item['Name'].toLowerCase().contains(query.toLowerCase()))
              .toList()));
    });
  }

  @override
  void initState() {
    super.initState();
    fetchItemsFromApi().then((_) {
      print(categoryKeys);

      setState(() {
        selectedCategory = categoryKeys.isNotEmpty ? categoryKeys[0] : 'phone';
        searchedDevices = devicesFuture;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
      create: (BuildContext context) => MyModel(),
      child: Scaffold(
          body: FutureBuilder(
              future: fetchItemsFromApi(),
              builder: (context, snapshot) {
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
                              top: 23.0, bottom: 16.0, left: 18.0, right: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Select Devices",
                                  style: TextStyle(
                                      color: Color(0xffE96E2B),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.0)),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 7.0),
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              filterSearchResults(value);
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color(0xffE96E2B),
                              ),
                              hintText: "Search Devices",
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9.0)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0),
                                borderSide:
                                    BorderSide(color: Color(0xffE96E2B)),
                              ),
                            ),
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
                                searchedDevices[selectedCategory]?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              final device =
                                  searchedDevices[selectedCategory]![index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: AssignCard(
                                        company: device['company'],
                                        model: device['Name'],
                                        deviceId: device['deviceid'],
                                        quantity: device['quantity'].toString(),
                                        myModel: Provider.of<MyModel>(context),
                                      ),
                                    ),
                                    Consumer<MyModel>(
                                      builder: (context, MyModel, child) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xffE96E2B),
                                              // elevation: 5.0,
                                              minimumSize: Size(30, 37),
                                              textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0))),
                                          onPressed: () {
                                            MyModel.addorRemovecount(
                                                device['deviceid'],
                                                device['Name']);

                                            print(MyModel.isSelectedItems);
                                          },
                                          child: !MyModel.isDeviceSelected(
                                                  device['deviceid'])
                                              ? Text("Add")
                                              : Text("remove"),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding: EdgeInsets.only(left: 8, top: 6),
                                height:
                                    MediaQuery.of(context).size.height * 0.055,
                                width: double.infinity,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Seel All selected Devices",
                                    style: TextStyle(
                                        color: Color(0xffE96E2B),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 10, bottom: 10, top: 10),
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: double.infinity,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 11.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Consumer<MyModel>(
                                              builder:
                                                  ((context, MyModel, child) {
                                                return Text(
                                                    "${MyModel.isSelectedItems.length} items Selected",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff474747),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15.0));
                                              }),
                                            ),
                                          ]),
                                      Consumer<MyModel>(
                                        builder: (context, MyModel, child) {
                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xffE96E2B),
                                                // elevation: 5.0,
                                                minimumSize: Size(107, 25),
                                                textStyle: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0))),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Emp_Assign_2(
                                                            isSelectedItems: MyModel
                                                                .isSelectedItems,
                                                          )));
                                            },
                                            child: Text(
                                              "Enter Customer details",
                                              style: TextStyle(
                                                  letterSpacing: 2,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              })),
    );
  }
}

class MyModel with ChangeNotifier {
  Set<Map<String, dynamic>> isSelectedItems = {};
  Set<int> selectedDeviceIds = {};

  bool isDeviceSelected(int deviceId) {
    return selectedDeviceIds.contains(deviceId);
  }

  Map<int, int> localQntMap = {};

  void updateLocalQnt(int deviceId, int value) {
    localQntMap[deviceId] = value;
    notifyListeners();
    print("jkkkkk $localQntMap");
  }

  void addorRemovecount(int deviceId, String name) {
    final item = {
      "deviceId": deviceId,
      "quantity": localQntMap[deviceId],
      "model": name,
    };

    final isAlreadySelected = isDeviceSelected(deviceId);

    if (!isAlreadySelected) {
      isSelectedItems.add(item);
      selectedDeviceIds.add(deviceId);
      print("add");
    } else {
      isSelectedItems.removeWhere((e) => e['deviceId'] == deviceId);
      selectedDeviceIds.remove(deviceId);
      print("remove");
    }
    notifyListeners();
  }
}
