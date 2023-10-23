import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:mobelease/screens/Employee/Emp_Assign_1.dart';
import 'package:mobelease/widgets/Emp_bottomAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/EmployeeDataCard.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class Emp_home extends StatefulWidget {
  const Emp_home({super.key});

  @override
  State<Emp_home> createState() => _Emp_homeState();
}

class _Emp_homeState extends State<Emp_home> {
  final AuthController authController = AuthController();
  String? empId;

  Future<List<Map<String, dynamic>>> viewAllSale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    empId = prefs.getInt('empId').toString();

    var url = Uri.parse('$baseUrl/sale/viewallsale');

    final token = await authController.getToken();

    print("token $token");
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(Duration(days: 2));
    final String endtime = DateFormat('yyyy-MM-dd').format(tomorrow);

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "starttime": "2021-10-12",
          "endtime": endtime,
          "status": "*all*",
          "empid": empId,
          "saletype": "*all*"
        }),
        headers: {'Cookie': token!, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> viewSalesData =
            jsonDecode(response.body)!['data'];
        print("veiw sal $viewSalesData");
        List<Map<String, dynamic>> salesList =
            List<Map<String, dynamic>>.from(viewSalesData.values);
        return salesList;
      } else {
        print("failed to load viewSalesData");
      }
    } catch (e) {
      return Future.error(e.toString());
    }
    return [];
  }

  String formatTimestamp(String timestamp) {
    final inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS");
    final outputFormat = DateFormat("dd/MM/yyyy");

    final parsedDate = inputFormat.parse(timestamp, true);
    return outputFormat.format(parsedDate);
  }

  @override
  void initState() {
    super.initState();

    viewAllSale();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 11.0, left: 11.0, right: 11.0),
              child: Appbar(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Emp_Assign_1(
                                empId: int.parse(empId!),
                              )));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Color(0xffE96E2B), width: 0.5),
                      color: Color(0xffFFF7ED)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/ShoppingCart.svg', // Replace with your SVG file path
                        // semanticsLabel: 'A red up arrow'
                      ),

                      // SvgPicture("assets/svgs/ShoppingCart.svg"),
                      Row(
                        children: [
                          Text(
                            'Sell Devices',
                            style: TextStyle(
                                color: Color(0xffE96E2B),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          Icon(
                            Icons.arrow_right_alt,
                            color: Color(0xffE96E2B),
                            size: 15,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 13.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Recent Selling",
                      style: TextStyle(
                          color: Color(0xffE96E2B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  SizedBox(
                    height: 8,
                  ),
                  FutureBuilder(
                      future: viewAllSale(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Placeholder for loading state
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<Map<String, dynamic>> salesData = snapshot.data!;
                          print(salesData);
                          return Container(
                            // Wrap the ListView with a Container to constrain its height
                            height: MediaQuery.of(context).size.height *
                                0.45, // Adjust the height as needed
                            child: ListView.builder(
                              itemCount: salesData.length,
                              itemBuilder: (BuildContext context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: EmployeeDataCard(
                                    cost: double.parse(
                                        salesData[index]['totalsale']),
                                    date: formatTimestamp(
                                        salesData[index]['timestamp']),
                                    name: salesData[index]['customername'],
                                    cash:
                                        salesData[index]['saletype'] == "cash",
                                    paid: salesData[index]['status'] == "paid",
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Emp_bottomAppBar(
        index: 0,
      ),
    );
  }
}
