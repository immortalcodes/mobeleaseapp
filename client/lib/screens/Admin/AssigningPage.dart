import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobelease/screens/Inventory/AddDevice.dart';
import 'package:mobelease/ui_sizes.dart';
import '../../controllers/auth_controller.dart';
import '../../globals.dart';
import '../../models/Inventory_Model.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/BottomAppBar.dart';
import '../../widgets/categories.dart';
import '../../widgets/AssignCardInv.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

// import 'item_model.dart';

class AssigningPage extends StatefulWidget {
  int? empId;
  Future<void> Function(int)? addorremoveFunction;
  List<dynamic>? deviceItems;
  AssigningPage(
      {super.key, this.empId, this.addorremoveFunction, this.deviceItems});

  @override
  State<AssigningPage> createState() => _AssigningPageState();
}

class _AssigningPageState extends State<AssigningPage> {
  ScrollController _scrollController = ScrollController();
  String selectedCategory = '';
  List<String> categoryKeys = [];
  Map<String, List<ItemModel>> devicesFuture = {};
  final AuthController authController = AuthController();

  Future<Map<String, List<ItemModel>>> fetchItemsFromApi() async {
    final token = await authController.getToken();

    var url = Uri.parse('$baseUrl/inv/viewallitem');
    final response = await http.post(
      url,
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      print("hjhj $data");
      final Map<String, List<ItemModel>> categorizedDevices = {};
      for (String m in data.keys) {
        List<ItemModel> devices = [];
        for (var deviceData in data[m]) {
          ItemModel.fromJson(deviceData);
          devices.add(ItemModel.fromJson(deviceData));
        }

        categorizedDevices[m] = devices;
      }
      print(categorizedDevices);
      categoryKeys = categorizedDevices.keys.toList();

      devicesFuture = categorizedDevices;

      return devicesFuture;
    } else {
      throw Exception('Failed to load items');
    }
  }

  void deleteDevice(int deviceId) async {
    final token = await authController.getToken();
    print(deviceId);
    var url = Uri.parse('$baseUrl/inv/deleteitem');
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
          subtitle: AutoSizeText('Cost: ${devices[index].cost}'),
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
    fetchItemsFromApi().then((_) {
      print(categoryKeys);

      setState(() {
        selectedCategory = categoryKeys.isNotEmpty ? categoryKeys[0] : 'phone';
      });
    });

    // Set default selected category to Phone
  }

  Future<void> fetchDevices() async {
    await fetchItemsFromApi();
    setState(() {});
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
            return AutoSizeText('Error: ${snapshot.error}');
          } else {
            Map<String, List<ItemModel>> categorizedDevices =
                snapshot.data as Map<String, List<ItemModel>>;
            return SafeArea(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: UiSizes(context: context).width_18),
                child: Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(top: UiSizes(context: context).height_11),
                      child: Appbar(),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(top: UiSizes(context: context).height_23, bottom: UiSizes(context: context).height_16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText("Categories",
                              style: TextStyle(
                                  color: Color(0xffE96E2B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddDeviceDialog(
                                            onDeviceAdded: fetchDevices,
                                          )));
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
                                AutoSizeText(
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
                            padding:  EdgeInsets.symmetric(horizontal: UiSizes(context: context).width_6,vertical: UiSizes(context: context).width_6),
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
                            print("devices $device");
                            return Padding(
                              padding:  EdgeInsets.symmetric(horizontal: UiSizes(context: context).width_8, vertical: UiSizes(context: context).height_8),
                              child: GestureDetector(
                                onDoubleTap: () async {
                                  bool isPresent = widget.deviceItems!.any(
                                    (deviceItem) =>
                                        deviceItem['deviceid'] ==
                                        device.deviceId,
                                  );

                                  if (!isPresent) {
                                    await widget
                                        .addorremoveFunction!(device.deviceId!);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: AutoSizeText("Device already present"),
                                      duration: Duration(seconds: 5),
                                    ));
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: AssignCardInv(
                                  company: device.company ?? "",
                                  model: device.deviceDetail ?? "",
                                  cost: device.cost ?? "0",
                                  storage: device.storage ?? "0",
                                  deviceId: device.deviceId ??
                                      0, // Pass the device ID
                                  onDelete:
                                      deleteDevice, // Pass the delete function
                                ),
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
      bottomNavigationBar: bottomAppBar(index: 1),
    );
  }
}
