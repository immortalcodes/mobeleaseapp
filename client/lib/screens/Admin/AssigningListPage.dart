import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../controllers/auth_controller.dart';
import '../../globals.dart';
import '../../models/Inventory_Model.dart';
import '../../widgets/AssigningPageCard.dart';
import '../../widgets/categories.dart';

class SecondPage extends StatelessWidget {
  final List<String> devices = ['Device 1', 'Device 2', 'Device 3'];
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
        List<ItemModel> devices = [];
        for (var deviceData in data[m]) {
          ItemModel.fromJson(deviceData);
          devices.add(ItemModel.fromJson(deviceData));
        }
        categorizedDevices[m] = devices;
      }
      print(categorizedDevices);
      devicesFuture = categorizedDevices;
      return devicesFuture;
    } else {
      throw Exception('Failed to load items');
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<ItemModel>>>(
      future: fetchItemsFromApi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, List<ItemModel>> categorizedDevices = snapshot.data!;
          print(snapshot.data!);
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  "Select a device",
                  style: TextStyle(color: Color(0xffE96E2B)),
                ),
                content: Column(
                  children: [
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
                                  selectedCategory = category;
                                });
                              },
                              selectedCategory: selectedCategory,
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
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: AssigningPageCard(
                                model: device.deviceDetail ?? "",
                                cost: device.cost ?? "0",
                                deviceId: device.deviceId ?? 0,
                                Storage: device.storage ?? "",
                                // onDelete: deleteDevice,
                                onTap: () {
                                  setState(() {
                                    Navigator.pop(context, device);
                                    // print(selectedDevices.first.deviceDetail);
                                  });
                                  // Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );

            },
          );
        }
      },
    );
  }
}
