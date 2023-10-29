import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:mobelease/widgets/Emp_bottomAppBar.dart';
import 'package:mobelease/widgets/EmployeeDataCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../widgets/Appbar.dart';

class Emp_Reports_1 extends StatefulWidget {
  const Emp_Reports_1({super.key});

  @override
  State<Emp_Reports_1> createState() => _Emp_Reports_1State();
}

class _Emp_Reports_1State extends State<Emp_Reports_1> {
  final AuthController authController = AuthController();
  String? empId;
  TextEditingController _startdateController = TextEditingController();
  TextEditingController _enddateController = TextEditingController();
  List<Map<String, dynamic>> statesList = [];

  Future<void> viewAllState(
      String starttime, String endtime, String status, String saleType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    empId = prefs.getInt('empId').toString();

    var url = Uri.parse('$baseUrl/sale/viewallsale');

    final token = await authController.getToken();

    print("token $token");

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "starttime": starttime,
          "endtime": endtime,
          "empid": empId,
          "status": status,
          "saletype": saleType
        }),
        headers: {'Cookie': token!, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> viewStatesData =
            jsonDecode(response.body)!['data'];
        print("veiw state: $viewStatesData");
        List<Map<String, dynamic>> salesList =
            List<Map<String, dynamic>>.from(viewStatesData.values);

        setState(() {
          statesList = salesList;
        });
      } else {
        print("failed to load viewStatesData");
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  String formatTimestamp(String timestamp) {
    final inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS");
    final outputFormat = DateFormat("dd/MM/yyyy");

    final parsedDate = inputFormat.parse(timestamp, true);
    return outputFormat.format(parsedDate);
  }

  String dropdownValue = 'paid';
  String dropdownsaleValue = 'credit';

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.48,
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Filter",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xffE96E2B),
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0)),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close, size: 20))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text("Choose date",
                  style:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 17.0)),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Starting from",
                            style: TextStyle(color: Colors.grey)),
                      ),
                      SizedBox(
                        width: 168,
                        height: 40,
                        child: TextField(
                          controller:
                              _startdateController, //editing controller of this TextField
                          decoration: InputDecoration(
                            hintText: 'Start Date',
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: Color(0xffE96E2B),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9.0),
                              borderSide: BorderSide(color: Color(0xffE96E2B)),
                            ),
                          ),
                          readOnly: true, // when true user cannot edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(), //get today's date
                                firstDate: DateTime(
                                    2000), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                              String formattedDate = DateFormat('yyyy-MM-dd')
                                  .format(
                                      pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                              print(
                                  formattedDate); //formatted date output using intl package =>  2022-07-04
                              //You can format date as per your need

                              setState(() {
                                _startdateController.text =
                                    formattedDate; //set foratted date to TextField value.
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("To", style: TextStyle(color: Colors.grey)),
                      ),
                      SizedBox(
                        width: 168,
                        height: 40,
                        child: TextField(
                          controller:
                              _enddateController, //editing controller of this TextField
                          decoration: InputDecoration(
                            hintText: 'End Date',
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: Color(0xffE96E2B),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9.0),
                              borderSide: BorderSide(color: Color(0xffE96E2B)),
                            ),
                          ),
                          readOnly: true, // when true user cannot edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(), //get today's date
                                firstDate: DateTime(
                                    2000), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                              String formattedDate = DateFormat('yyyy-MM-dd')
                                  .format(
                                      pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                              print(
                                  formattedDate); //formatted date output using intl package =>  2022-07-04
                              //You can format date as per your need

                              setState(() {
                                _enddateController.text =
                                    formattedDate; //set foratted date to TextField value.
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Status",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 17.0)),
                      SizedBox(
                        height: 5,
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['paid', 'dues', "*all*"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Sale Type ",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 17.0)),
                      SizedBox(
                        height: 5,
                      ),
                      DropdownButton<String>(
                        value: dropdownsaleValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownsaleValue = newValue!;
                          });
                        },
                        items: <String>['credit', 'cash', "*all*"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 60,
                width: 341,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffE96E2B),
                      // elevation: 5.0,
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  onPressed: () async {
                    await viewAllState(
                        _startdateController.text,
                        _enddateController.text,
                        dropdownValue,
                        dropdownsaleValue);

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Filter applied successfully"),
                      duration: Duration(seconds: 5),
                    ));
                  },
                  child: Text(
                    "Filter",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 11.0, left: 11.0, right: 11.0),
              child: Appbar(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 23.0, bottom: 16.0, left: 18.0, right: 18.0),
                  child: Text("Past Orders",
                      style: TextStyle(
                          color: Color(0xffE96E2B),
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0)),
                ),
                IconButton(
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  icon: Icon(
                    Icons.filter_alt,
                    size: 20,
                  ),
                  color: Colors.orange,
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: statesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/Reports');
                          },
                          child: EmployeeDataCard(
                            cost: statesList[index]['totalsale'],
                            date:
                                formatTimestamp(statesList[index]['timestamp']),
                            name: statesList[index]['customername'] ?? "",
                            cash: statesList[index]['saletype'] == "cash",
                            paid: statesList[index]['status'] == "paid",
                          )),
                    );
                  }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Emp_bottomAppBar(index: 2),
    );
  }
}
