import 'package:flutter/material.dart';
import 'package:mobelease/widgets/InstallmentsCard.dart';
import 'package:mobelease/widgets/TextFieldWidget.dart';

import '../../widgets/Appbar.dart';
import '../../widgets/PaymentCard.dart';
import '../../widgets/PaymentTag.dart';
import 'package:intl/intl.dart';

class PaymentCredit extends StatefulWidget {
  const PaymentCredit({super.key});

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
                          Text("(Cash)",
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
                        PaymentCard(
                            item: 'iPhone13',
                            quantity: 1,
                            price: 5300,
                            total: 5300),
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
                                '\$5300',
                                style: TextStyle(
                                    color: Color(0xffE96E2B),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PaymentTag(Tag: "Credit Left"),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              Text(
                                '\$2500',
                                style: TextStyle(
                                    color: Color(0xffE96E2B),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
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
                                Tag: 'Installments',
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                              ),
                              PaymentTag(
                                Tag: 'Date',
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              PaymentTag(
                                Tag: 'Price',
                              ),
                            ],
                          ),
                        ),
                        InstallmentsCard(
                            installments: 'Down Payment',
                            date: '03/04/22',
                            price: 5300),
                        InstallmentsCard(
                            installments: '1st EMI',
                            date: '03/04/22',
                            price: 1000),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffECECEC),
                                  // elevation: 5.0,
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                              onPressed: () {
                                _showAddEmiDialog(context);
                              },
                              child: Text(
                                "Add EMI",
                                style: TextStyle(
                                    color: Color(0xffE96E2B),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
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
                                      Text("5 items Selected",
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
                                  onPressed: () {},
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
