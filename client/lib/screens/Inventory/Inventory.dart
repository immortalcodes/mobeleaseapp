import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../globals.dart';
import '../../models/Inventory_Model.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/BottomAppBar.dart';
import '../../widgets/categories.dart';
import '../../widgets/AssignCardInv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
// import 'item_model.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  ScrollController _scrollController = ScrollController();
  String selectedCategory = '';
  Map<String, List<ItemModel>> devicesFuture = {};
  final AuthController authController = AuthController();
  Future<Map<String, List<ItemModel>>> fetchItemsFromApi() async {
    final token = await authController.getToken();
    var url = Uri.https(baseUrl, '/inv/viewallitem');
    final response = await http.post(
      url,
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      final Map<String, List<ItemModel>> categorizedDevices = {};
      for (String m in data.keys) {
        // print(data[m]);
        // categorizedDevices[m] = data[m];
        // print(categorizedDevices);
        List<ItemModel> devices = [];
        for (var deviceData in data[m]) {
          ItemModel.fromJson(deviceData);
          devices.add(ItemModel.fromJson(deviceData));
          // print(deviceData);
        }
        // print(devices);
        categorizedDevices[m] = devices;
      }
      print(categorizedDevices);
      devicesFuture = categorizedDevices;
      // print(devicesFuture);
      return devicesFuture;
    } else {
      throw Exception('Failed to load items');
    }
  }

  void deleteDevice(int deviceId) async {
    final token = await authController.getToken();
    print(deviceId);
    var url = Uri.https(baseUrl, '/inv/deleteitem');
    final response = await http.post(
      url,
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
      body: jsonEncode({'deviceid': deviceId}),
    );

    if (response.statusCode == 200) {
      // Device deleted successfully
      print('Device deleted successfully');
      setState(() {});
      // Refresh the inventory or update the UI as needed
    } else {
      print('Failed to delete device. Status code: ${response.statusCode}');
      // Handle the error or show a message to the user
    }
  }

  ListView buildDeviceList(List<ItemModel> devices) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          // title: Text(devices[index].deviceDetail),
          subtitle: Text('Cost: ${devices[index].cost}'),
          trailing: IconButton(
            icon: Icon(Icons.delete), // Add a delete icon
            onPressed: () {
              // deleteItem(devices[index].deviceId);
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    selectedCategory = 'phone'; // Set default selected category to Phone
  }

  @override
  Widget build(BuildContext context) {
    // ScrollController _scrollController = ScrollController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: fetchItemsFromApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Placeholder for loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, List<ItemModel>> categorizedDevices =
                snapshot.data as Map<String, List<ItemModel>>;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 11.0),
                      child: Appbar(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 23.0, bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Categories",
                              style: TextStyle(
                                  color: Color(0xffE96E2B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/AddDevice');
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 6.5,
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.add,
                                    color: Color(0xffE96E2B),
                                    size: 13,
                                  ),
                                ),
                                Text(
                                  "Add Device",
                                  style: TextStyle(color: Color(0xffE96E2B)),
                                )
                              ],
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
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              categorizedDevices[selectedCategory]?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            final device =
                                categorizedDevices[selectedCategory]![index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AssignCardInv(
                                model: device.deviceDetail ?? "",
                                cost: device.cost ?? "0",
                                deviceId:
                                    device.deviceId ?? 0, // Pass the device ID
                                onDelete:
                                    deleteDevice, // Pass the delete function
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: bottomAppBar(index:1),
    );
  }
}
