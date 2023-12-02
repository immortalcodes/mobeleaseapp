import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:mobelease/screens/Employee/Reports.dart';
import 'package:http/http.dart' as http;

class EmployeeDataCard extends StatefulWidget {
  late double cost;
  late String date;
  late String name;
  late bool cash;
  late bool paid;
  int? saleId;

  EmployeeDataCard(
      {required this.cost,
      required this.date,
      required this.name,
      required this.cash,
      required this.paid,
      this.saleId});

  @override
  State<EmployeeDataCard> createState() => _EmployeeDataCardState();
}

class _EmployeeDataCardState extends State<EmployeeDataCard> {
  final AuthController authController = AuthController();
  List<Map<String, dynamic>> singlesalesList = [];
  List<Map<String, dynamic>> installmentsList = [];

  Future<void> viewSingleInstallment() async {
    var url = Uri.parse('$baseUrl/sale/viewsinglesale');

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
        final Map<String, dynamic> viewSingleSalesData =
            jsonDecode(response.body)!['data'];
        singlesalesList =
            List<Map<String, dynamic>>.from(viewSingleSalesData.values);
      } else {
        print("failed to load viewSalesData");
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 73.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '\$${widget.cost}',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    saleType(context, widget.cash)
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  '${widget.date} \- ${widget.name}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [paymentStatus(context, widget.paid)],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.032,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffE96E2B),
                        // elevation: 5.0,
                        minimumSize: Size(87, 25),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    onPressed: () async {
                      await viewSingleInstallment();

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Reports(
                                    saleId: widget.saleId!,
                                    singlesalesList: singlesalesList,
                                  )));
                    },
                    child: Text(
                      "View Details",
                      style: TextStyle(
                          fontSize: 10.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget saleType(BuildContext context, bool isCash) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.12,
    height: MediaQuery.of(context).size.height * 0.025,
    decoration: BoxDecoration(
      color: isCash ? Color(0xffD2FDE6) : Color(0xffFFF5CA),
      borderRadius: BorderRadius.circular(30),
    ),
    child: isCash
        ? Text(
            "Cash",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xff00974F)),
          )
        : Text(
            "Credit",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xffF17400)),
          ),
  );
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
