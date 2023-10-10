import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AssignCardMain extends StatefulWidget {
  late String model;
  late int quantity;
  late int deviceId;
  late String cost;
  late int empId;
  late int totalPrice;
  late String company;
  final void Function(int) updateTotalPrice;

  final Function onDelete;

  AssignCardMain({
    required this.model,
    required this.quantity,
    required this.deviceId,
    required this.cost,
    required this.empId,
    required this.totalPrice,
    required this.company,
    required this.updateTotalPrice,
    required this.onDelete,
  });

  @override
  State<AssignCardMain> createState() => _AssignCardMainState();
}

class _AssignCardMainState extends State<AssignCardMain> {
  final AuthController authController = AuthController();
  int localQuantity = 0;
  Future<void> addOrremoveDevice(int updatedQuantity) async {
    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/inv/editassign');

    final response = await http.post(
      url,
      body: jsonEncode({
        'empid': widget.empId,
        'devices': [
          {'deviceid': widget.deviceId, 'quantity': updatedQuantity}
        ]
      }),
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      print("edited successfully");
    } else {
      print("failed to edit devices");
    }
  }

  void updateLocalStorage(int deviceId, int newQuantity) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedDevices = prefs.getString('devices');
    if (encodedDevices != null) {
      final List<dynamic> decodedDevices = jsonDecode(encodedDevices);
      print("Helloooo $decodedDevices");

      for (var device in decodedDevices) {
        if (device['deviceid'] == deviceId) {
          device['quantity'] = newQuantity;
          break;
        }

        await prefs.setString('devices', jsonEncode(decodedDevices));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    localQuantity = widget.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 47.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: Offset(0, 8),
            ),
          ],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                SvgPicture.asset('assets/svgs/MobileTag.svg'),
                SizedBox(
                  width: 15,
                ),
                Text(widget.company,
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                SizedBox(
                  width: 15,
                ),
                Text(widget.model,
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 5),
                Text("\$ ${widget.cost}",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey)),
                SizedBox(width: 15),
                GestureDetector(
                  child: CircleAvatar(
                    radius: 10.0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.remove_circle,
                      color: Color(0xffE96E2B),
                    ),
                  ),
                  onTap: () async {
                    if (localQuantity == 1) {
                      await widget.onDelete(widget.deviceId);
                    } else {
                      setState(() {
                        localQuantity = localQuantity - 1;
                        widget.totalPrice -= int.parse(widget.cost);
                      });
                    }

                    // await addOrremoveDevice(widget.quantity);
                    // widget.updateTotalPrice(widget.totalPrice);
                  },
                ),
                SizedBox(width: 5),
                Text(
                  localQuantity.toString(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  child: CircleAvatar(
                    radius: 10.0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.add_circle,
                      color: Color(0xffE96E2B),
                    ),
                  ),
                  onTap: () async {
                    print("%%% ${widget.deviceId}");

                    setState(() {
                      localQuantity = localQuantity + 1;

                      widget.totalPrice += int.parse(widget.cost);
                    });
                    updateLocalStorage(widget.deviceId, localQuantity);
                    // await addOrremoveDevice(widget.quantity);

                    // widget.updateTotalPrice(widget.totalPrice);
                  },
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
