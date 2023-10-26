import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mobelease/widgets/PaymentCard.dart';

import '../../widgets/Appbar.dart';
import '../../widgets/PaymentTag.dart';

class PaymentCash extends StatefulWidget {
  final Set<Map<String, dynamic>> isSelectedItems;

  const PaymentCash({super.key, required this.isSelectedItems});

  @override
  State<PaymentCash> createState() => _PaymentCashState();
}

class _PaymentCashState extends State<PaymentCash> {
  List<Map<String, dynamic>> convertedSelectedItems = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
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
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
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
                                    Text(
                                        "${widget.isSelectedItems.length}  items Selected",
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
    );
  }
}
