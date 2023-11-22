import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:mobelease/widgets/Emp_bottomAppBar.dart';
import 'package:intl/intl.dart';
import 'package:mobelease/widgets/TextFieldWidget.dart';
import 'package:mobelease/widgets/saleDetailsCard.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/PaymentTag.dart';
import '../../widgets/ReportsInstallmentsCard.dart';
import 'package:http/http.dart' as http;

class Reports extends StatefulWidget {
  List<Map<String, dynamic>>? singlesalesList;

  int saleId;

  Reports({this.singlesalesList, required this.saleId});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  TextEditingController _EMIValController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  String dropdownValue = 'paid';
  final AuthController authController = AuthController();

  List<Map<String, dynamic>> installmentList = [];

  Future<List<Map<String, dynamic>>> viewInstallment() async {
    var url = Uri.parse('$baseUrl/sale/viewinstallment');

    final token = await authController.getToken();
    print("kdkdkd ${widget.saleId}");
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "saleid": widget.saleId,
        }),
        headers: {'Cookie': token!, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> viewinstallmentData =
            jsonDecode(response.body)!['data'];

        Map<String, dynamic> installments = viewinstallmentData['installments'];
        installmentList = List<Map<String, dynamic>>.from(installments.values);
        return installmentList;
      } else {
        print("failed to load viewSalesData");
      }
    } catch (e) {
      return Future.error(e.toString());
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>>? saleitemsList = List<Map<String, dynamic>>.from(
        widget.singlesalesList![0]['itemarray'].values);

    // List<Map<String, dynamic>>? installmentsList =
    //     List<Map<String, dynamic>>.from(
    //         widget.singlesalesList![0]['installments'].values);

    void onAddEmi() {
      setState(() {});
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text("Sale Details",
                        style: TextStyle(
                            color: Color(0xffE96E2B),
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(DateTime.parse(
                              widget.singlesalesList![0]['timestamp'])),
                          style: TextStyle(
                              color: Color(0xffE96E2B),
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${DateFormat('HH:mm').format(DateTime.parse(widget.singlesalesList![0]['timestamp']).toLocal())} IST",
                          style: TextStyle(
                              color: Color(0xffE96E2B),
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "To",
                            style: TextStyle(color: Color(0xffE96E2B)),
                          ),
                          Text(widget.singlesalesList![0]['customername'],
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                          Text(widget.singlesalesList![0]['phoneno'],
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          Text(
                            "Language: ${widget.singlesalesList![0]['language']}",
                            style: TextStyle(
                                color: Color(0xffE96E2B),
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              paymentStatus(
                                  context,
                                  widget.singlesalesList![0]['status'] ==
                                      'paid')
                            ],
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Row(children: [
                              Text(
                                "Change Status",
                                style: TextStyle(color: Color(0xffE96E2B)),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Color(0xffE96E2B),
                              )
                            ]),
                          ),
                          Row(
                            children: [
                              Text(
                                "Sold by:",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Text(
                                "Name",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
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
                      for (var item in saleitemsList)
                        SaleDetailsCard(
                          itemName: item['devicename'],
                          quantity: item['quantity'],
                          sellprice: item['sellprice'],
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  PaymentTag(Tag: "Total Sale:"),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.06,
                                  ),
                                  Text(
                                    '\$ ${widget.singlesalesList![0]['totalsale']}',
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
                                  PaymentTag(Tag: "Credit Left:"),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.06,
                                  ),
                                  Text(
                                    '\$ ${widget.singlesalesList![0]['amountleft']}',
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
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
                  child: FutureBuilder(
                      future: viewInstallment(),
                      builder: (context, snapshot) {
                        List<Map<String, dynamic>>? installmentData =
                            snapshot.data;

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.connectionState ==
                                ConnectionState.done &&
                            installmentData!.isEmpty) {
                          return SizedBox(
                            height: 20,
                          );
                        } else {
                          return SizedBox(
                            height: installmentData!.length == 1 ? 150 : 280,
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(installmentData.length,
                                    (index) {
                                  var installment = installmentData[index];
                                  print("kfkkffk $installmentData}");
                                  return ReportsInstallmentsCard(
                                    saleId: installmentData[0]['saleid'],
                                    installmentId: index +
                                        1, // Pass the installment index here
                                    deadline: installment['deadline'] == null
                                        ? "--"
                                        : DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(
                                                installment['deadline'])),
                                    promiseamount:
                                        installment['promisedamount'] ?? 0,
                                    status: installment['status'] ?? "-",
                                    amountpaid: installment['amountpaid'] ?? 0,
                                    paymentdate: installment['paymentdate'] ==
                                            null
                                        ? "--"
                                        : DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(
                                                installment['paymentdate'])),
                                  );
                                }),
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ),
              Center(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffE96E2B),
                          // elevation: 5.0,
                          textStyle: TextStyle(
                            fontSize: 18,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0))),
                      onPressed: () {
                        _showAddEmiDialog(context, onAddEmi);
                      },
                      child: Text(
                        "Add EMI",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Emp_bottomAppBar(
        index: 2,
      ),
    );
  }

  Future<void> _showAddEmiDialog(
      BuildContext context, VoidCallback onAddEMI) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
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
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12),
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
                                  'paid',
                                  'topay'
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
                      var url = Uri.parse('$baseUrl/sale/addinstallment');

                      final token = await authController.getToken();

                      try {
                        print("debug ####33 ${widget.saleId}");
                        final response = await http.post(
                          url,
                          body: dropdownValue == 'paid'
                              ? jsonEncode({
                                  "saleid": widget.saleId,
                                  "status": dropdownValue,
                                  "paymentdate": _dateController.text,
                                  "amountpaid":
                                      int.parse(_EMIValController.text)
                                })
                              : jsonEncode({
                                  "saleid": widget.saleId,
                                  "status": dropdownValue,
                                  "deadline": _dateController.text,
                                  "promisedamount":
                                      int.parse(_EMIValController.text),
                                }),
                          headers: {
                            'Cookie': token!,
                            'Content-Type': 'application/json'
                          },
                        );

                        if (response.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("added installment sucessfully"),
                            duration: Duration(seconds: 5),
                          ));
                          onAddEMI.call();
                          Navigator.pop(context);
                        } else {
                          print("failed to add installment");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("failed to add installment!"),
                            duration: Duration(seconds: 5),
                          ));
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: Text(
                      "ADD",
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
}

class Cash extends StatelessWidget {
  const Cash({super.key});

  @override
  Container build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      height: MediaQuery.of(context).size.height * 0.025,
      decoration: BoxDecoration(
        color: Color(0xffD2FDE6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        "Cash",
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xff00974F)),
      ),
    );
  }
}

class Credit extends StatelessWidget {
  const Credit({super.key});

  @override
  Container build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.12,
      height: MediaQuery.of(context).size.height * 0.025,
      decoration: BoxDecoration(
        color: Color(0xffFFF5CA),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        "Credit",
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xffF17400)),
      ),
    );
  }
}

class Paid extends StatelessWidget {
  const Paid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.12,
      height: MediaQuery.of(context).size.height * 0.025,
      decoration: BoxDecoration(
        color: Color(0xff8fb4e7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          CircleAvatar(
              radius: 5,
              backgroundColor: Color(0xff116ef3),
              child: Icon(
                Icons.done,
                color: Colors.white,
                size: 5,
              )),
          Text(
            "Paid",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xff0e64e0)),
          ),
        ],
      ),
    );
  }
}

Widget paymentStatus(BuildContext context, isPaid) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.17,
    height: MediaQuery.of(context).size.height * 0.025,
    decoration: isPaid
        ? BoxDecoration(
            color: Color(0xff8fb4e7),
            borderRadius: BorderRadius.circular(30),
          )
        : BoxDecoration(
            color: Color(0xffFFEFEF),
            borderRadius: BorderRadius.circular(30),
          ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
            radius: 5,
            backgroundColor: isPaid ? Color(0xff116ef3) : Color(0xffF94E4E),
            child: Icon(
              Icons.done,
              color: Colors.white,
              size: 5,
            )),
        isPaid
            ? Text(
                "Paid",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff0e64e0)),
              )
            : Text(
                "Dues",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xffF94E4E)),
              ),
      ],
    ),
  );
}
