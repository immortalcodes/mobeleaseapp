import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:mobelease/screens/Employee/Emp_Reports_1.dart';
import 'package:mobelease/widgets/InstallmentsCard.dart';
import 'package:mobelease/widgets/TextFieldWidget.dart';

import '../../widgets/Appbar.dart';
import '../../widgets/PaymentCard.dart';
import '../../widgets/PaymentTag.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PaymentCredit extends StatefulWidget {
  final Set<Map<String, dynamic>> isSelectedItems;
  final String cName;
  final String cPhoneno;
  final String cImage;
  final String cFarm;
  final String cUnit;
  final bool cAlert;
  final String clangauge;

  const PaymentCredit(
      {super.key,
      required this.isSelectedItems,
      required this.cName,
      required this.cPhoneno,
      required this.cImage,
      required this.cFarm,
      required this.cUnit,
      required this.cAlert,
      required this.clangauge});

  @override
  State<PaymentCredit> createState() => _PaymentCreditState();
}

String? EMIVal = " ";
TextEditingController _EMIValController = TextEditingController(text: EMIVal);
TextEditingController _dateController = TextEditingController();

class _PaymentCreditState extends State<PaymentCredit> {
  Future<void> _showAddEmiDialog(BuildContext context) async {
    DateTime? selectedDate;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add EMI',
            style: TextStyle(color: Color(0xffE96E2B)),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Amount of EMI",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12)),
                    TextFieldWidget(
                        profileField: false,
                        hint: '\$980',
                        controller: _EMIValController),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Date",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                    ),
                    TextField(
                      controller:
                          _dateController, //editing controller of this TextField
                      decoration: InputDecoration(
                        hintText: 'Select Date',
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
                          String formattedDate = DateFormat('yyyy-MM-dd').format(
                              pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                          print(
                              formattedDate); //formatted date output using intl package =>  2022-07-04
                          //You can format date as per your need

                          setState(() {
                            _dateController.text =
                                formattedDate; //set foratted date to TextField value.
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffE96E2B),
                      // elevation: 5.0,
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  onPressed: () {},
                  child: Text(
                    "ADD",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  double totalPrice = 0.0;
  int salePrice = 0;
  Map<int, int> updatedPrices = {};
  void onUpdatetotalprice(int deviceId, int newsalePrice) {
    updatedPrices[deviceId] = newsalePrice;
    setState(() {
      salePrice = newsalePrice;
      convertedSelectedItems = widget.isSelectedItems.map((item) {
        return {
          'deviceid': item['deviceId'],
          'quantity': item['quantity'],
          'sellprice': updatedPrices[item['deviceId']] ?? 0
        };
      }).toList();

      totalPrice = convertedSelectedItems.fold(0, (total, item) {
        final quantity = int.parse(item['quantity'].toString());
        final sellPrice = double.parse(item['sellprice'].toString());
        return total + (quantity * sellPrice);
      });
    });

    print("djjd $convertedSelectedItems");
  }

  final AuthController authController = AuthController();
  List<Map<String, dynamic>> convertedSelectedItems = [];

  Future<void> onPayment() async {
    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/sale/makesale');

    final response = await http.post(
      url,
      body: jsonEncode({
        "type": "credit",
        "customername": widget.cName,
        "customeridimage": widget.cImage,
        "phoneno": widget.cPhoneno,
        "language": widget.clangauge,
        "unit": widget.cUnit,
        "farm": widget.cFarm,
        "itemarray": convertedSelectedItems,
        "paymentalert": widget.cAlert
      }),
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print("sale is make sucessful");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("sale is make sucessful"),
        duration: Duration(seconds: 5),
      ));

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Emp_Reports_1()));
      print(response.body);
    } else {
      print("error: ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 11.0, left: 11.0, right: 11.0),
                  child: Appbar(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 23.0, bottom: 16.0, left: 18.0, right: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Payment",
                              style: TextStyle(
                                  color: Color(0xffE96E2B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.0)),
                          Text("(Credit)",
                              style: TextStyle(
                                  color: Color(0xffE96E2B),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20.0)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 12.0,
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.arrow_back,
                            color: Color(0xffE96E2B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 18.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8.0,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PaymentTag(
                                Tag: 'Item',
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                              ),
                              PaymentTag(
                                Tag: 'Quantity',
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              PaymentTag(
                                Tag: 'Price',
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              PaymentTag(
                                Tag: 'Total',
                              ),
                            ],
                          ),
                        ),
                        for (var item in widget.isSelectedItems)
                          PaymentCard(
                            id: item['deviceId'],
                            item: item['model'],
                            onUpdateprice: onUpdatetotalprice,
                            quantity: int.parse(item['quantity']),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PaymentTag(Tag: "Total Sale"),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              Text(
                                '\$ $totalPrice',
                                style: TextStyle(
                                    color: Color(0xffE96E2B),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //       vertical: 8.0, horizontal: 18.0),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Colors.white,
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black12,
                //           blurRadius: 8.0,
                //           offset: Offset(0, 8),
                //         ),
                //       ],
                //     ),
                //     child: Column(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.symmetric(
                //               horizontal: 30.0, vertical: 8),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               PaymentTag(
                //                 Tag: 'Installments',
                //               ),
                //               SizedBox(
                //                 width: MediaQuery.of(context).size.width * 0.2,
                //               ),
                //               PaymentTag(
                //                 Tag: 'Date',
                //               ),
                //               SizedBox(
                //                 width: MediaQuery.of(context).size.width * 0.05,
                //               ),
                //               PaymentTag(
                //                 Tag: 'Price',
                //               ),
                //             ],
                //           ),
                //         ),
                //         InstallmentsCard(
                //             installments: 'Down Payment',
                //             date: '03/04/22',
                //             price: 5300),
                //         InstallmentsCard(
                //             installments: '1st EMI',
                //             date: '03/04/22',
                //             price: 1000),
                //         Padding(
                //             padding: const EdgeInsets.symmetric(
                //                 vertical: 8.0, horizontal: 16),
                //             child: ElevatedButton(
                //               style: ElevatedButton.styleFrom(
                //                   backgroundColor: Color(0xffECECEC),
                //                   // elevation: 5.0,
                //                   textStyle: TextStyle(
                //                     fontSize: 18,
                //                   ),
                //                   shape: RoundedRectangleBorder(
                //                       borderRadius:
                //                           BorderRadius.circular(20.0))),
                //               onPressed: () {
                //                 _showAddEmiDialog(context);
                //               },
                //               child: Text(
                //                 "Add EMI",
                //                 style: TextStyle(
                //                     color: Color(0xffE96E2B),
                //                     fontSize: 12,
                //                     fontWeight: FontWeight.w500),
                //               ),
                //             )),
                //       ],
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 10, bottom: 10, top: 10),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: double.infinity,
                          color: Colors.white,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 11.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          "${widget.isSelectedItems.length} items Selected",
                                          style: TextStyle(
                                              color: Color(0xff474747),
                                              fontSize: 13.0)),
                                    ]),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xffE96E2B),
                                      // elevation: 5.0,
                                      textStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0))),
                                  onPressed: onPayment,
                                  child: Text(
                                    "Complete Payment",
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
