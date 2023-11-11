import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:mobelease/widgets/PaymentTag.dart';
import 'package:mobelease/widgets/TextFieldWidget.dart';
import 'package:http/http.dart' as http;

class ReportsInstallmentsCard extends StatefulWidget {
  int installmentId;
  String deadline = "";
  int promiseamount = 0;
  String status;
  int amountpaid;
  String paymentdate = "";
  int saleId;

  ReportsInstallmentsCard(
      {required this.amountpaid,
      required this.deadline,
      required this.paymentdate,
      required this.status,
      required this.saleId,
      required this.installmentId,
      required this.promiseamount});

  @override
  State<ReportsInstallmentsCard> createState() =>
      _ReportsInstallmentsCardState();
}

class _ReportsInstallmentsCardState extends State<ReportsInstallmentsCard> {
  TextEditingController _amountPaidController = TextEditingController();
  TextEditingController _paymentDateController = TextEditingController();
  String dropdownValue = 'pay';
  final AuthController authController = AuthController();

  Future<void> _updateEMIDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
              'Update EMI',
              style: TextStyle(color: Color(0xffE96E2B)),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Paid Amount of EMI",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12)),
                      TextFieldWidget(
                          profileField: false,
                          hint: '\$980',
                          controller: _amountPaidController),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payment Date",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                      TextField(
                        controller:
                            _paymentDateController, //editing controller of this TextField
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
                              _paymentDateController.text =
                                  formattedDate; //set foratted date to TextField value.
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text("Status: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 13.0)),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            height: 35,
                            width: 80,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                underline: Container(
                                  height: 0,
                                  color: Colors.black38,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                items: <String>[
                                  'pay',
                                  'void'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
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
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    onPressed: () async {
                      var url = Uri.parse('$baseUrl/sale/updateinstallment');

                      final token = await authController.getToken();

                      try {
                        final response = await http.post(
                          url,
                          body: jsonEncode({
                            "installmentid": widget.installmentId,
                            "saleid": widget.saleId,
                            "status": dropdownValue,
                            "paymentdate": _paymentDateController.text,
                            "amountpaid": int.parse(_amountPaidController.text)
                          }),
                          headers: {
                            'Cookie': token!,
                            'Content-Type': 'application/json'
                          },
                        );

                        if (response.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("update installment sucessfully"),
                            duration: Duration(seconds: 5),
                          ));
                          Navigator.pop(context);
                        } else {
                          print("failed to update installment");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("failed to update installment!"),
                            duration: Duration(seconds: 5),
                          ));
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: Text(
                      "UPDATE",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              )
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 143,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Colors.black12, width: 0.5),
              bottom: BorderSide(color: Colors.black12, width: 0.8))),
      child: Column(
        children: [
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 20.0, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PaymentTag(
                    Tag: 'Installments',
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.11,
                  ),
                  PaymentTag(
                    Tag: 'Deadline',
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  PaymentTag(
                    Tag: 'Promise Amount',
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      "${widget.installmentId}",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
                      textAlign: TextAlign.center,
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.002,
                ),
                Text(
                  widget.deadline,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Text(
                  '\$ ${widget.promiseamount}',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                ),
              ],
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 10.0, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PaymentTag(
                    Tag: 'Payment Date',
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                  ),
                  PaymentTag(
                    Tag: 'Amount Paid',
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                  ),
                  PaymentTag(
                    Tag: 'Status',
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.08,
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    widget.paymentdate,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.08,
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    '\$ ${widget.amountpaid}',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.08,
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    widget.status,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
              onPressed: () {
                _updateEMIDialog(context);
              },
              icon: Icon(Icons.edit, size: 15),
              style: ElevatedButton.styleFrom(minimumSize: Size(100, 25)),
              label: Text("Update EMI"))
        ],
      ),
    );
  }
}
