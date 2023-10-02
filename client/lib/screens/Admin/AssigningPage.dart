import 'AssigningListPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobelease/widgets/Appbar.dart';
import 'package:mobelease/widgets/AssignCard.dart';

import '../../models/Inventory_Model.dart';

import '../../widgets/buttons.dart';

class DeviceSelectionScreen extends StatefulWidget {
  @override
  _DeviceSelectionScreenState createState() => _DeviceSelectionScreenState();
}

class _DeviceSelectionScreenState extends State<DeviceSelectionScreen> {
  late List<ItemModel> selectedDevices = [];
  void _navigateToSecondPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondPage()),
    );

    if (result != null) {
      setState(() {
        selectedDevices.add(result);
        print(result);
      });
    }
  }

  Map<int, int> deviceQuantities = {};
  void _updateQuantity(int modelid, int quantity) {
    setState(() {
      print(quantity);
      print(modelid);
      ItemModel? selectedDevice = selectedDevices.firstWhere(
        (device) => device.deviceId == modelid,
      );
      if (selectedDevice != null) {
        // You have found the corresponding device
        // You can now access its details
        print('Device Model: ${selectedDevice.deviceDetail}');
        print('Storage: ${selectedDevice.storage}');
      } else {
        print('Device with ID $modelid not found.');
      }
      // print(selectedDevices);
      deviceQuantities[modelid] = quantity; // Update the map
    });
  }
  // final int sum=0;

  void _assign() async {
    for (var device in selectedDevices) {}
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var device in selectedDevices) {
      int quantity = deviceQuantities[device.deviceId] ?? 0;
      double cost = (device.cost as num).toDouble(); // Cast to double
      totalPrice += cost * quantity;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 11.0, left: 11.0, right: 11.0),
              child: Appbar(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 23.0, bottom: 16.0, left: 11.0, right: 11.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Add to Cart",
                          style: TextStyle(
                              color: Color(0xffE96E2B),
                              fontWeight: FontWeight.w600,
                              fontSize: 20.0)),
                      Icon(
                        Icons.arrow_right_alt,
                        color: Color(0xffE96E2B),
                        size: 50,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _navigateToSecondPage(context);
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
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: selectedDevices.length,
                itemBuilder: (BuildContext context, int index) {
                  final device = selectedDevices[index];
                  print(selectedDevices.length);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    child: AssignCard(
                      model: device.deviceDetail ?? " ",
                      storage: device.cost ?? '0',
                      onQuantityChanged: (newQuantity) {
                        _updateQuantity(device.deviceId ?? 1, newQuantity);
                      },
                    ),
                  );
                },
              ),
            ),
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Total Price",
                                  style: TextStyle(
                                      color: Color(0xff474747),
                                      fontSize: 15.0)),
                              Text("\${totalPrice}",
                                  style: TextStyle(
                                      color: Color(0xffE96E2B),
                                      fontSize: 20.0)),
                            ],
                          ),
                          BlackButton(
                                  buttonText: "Assign",
                                  Width: 106,
                                  Height: 29,
                                  Radius: 13,
                                  onpress: () {})
                              .buildBlackButton()
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
}
