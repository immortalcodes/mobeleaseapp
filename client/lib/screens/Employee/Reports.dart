import 'package:flutter/material.dart';
import 'package:mobelease/widgets/Emp_bottomAppBar.dart';

import '../../widgets/Appbar.dart';
import '../../widgets/InstallmentsCard.dart';
import '../../widgets/PaymentCard.dart';
import '../../widgets/PaymentTag.dart';
import '../../widgets/ReportsInstallmentsCard.dart';

class Reports extends StatefulWidget {
  late bool cash;
  late bool paid;
  late bool dues;
  Reports({required this.cash, required this.dues, required this.paid});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  PaymentType() {
    return widget.cash ? Cash() : Credit();
  }

  IsPaid() {
    return widget.paid ? Paid() : CreditsLeft();
  }

  Dues() {
    return widget.cash ? Duesleft() : NoDues();
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
                        "Date",
                        style:
                            TextStyle(color: Color(0xffE96E2B), fontSize: 10),
                      ),
                      Text(
                        "Time IST",
                        style:
                            TextStyle(color: Color(0xffE96E2B), fontSize: 10),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
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
                        Text("Name"),
                        Text("Mobile No."),
                        Text(
                          "Language:French",
                          style: TextStyle(color: Color(0xffE96E2B)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            IsPaid(),
                            Dues(),
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
                    PaymentCard(item: 'iPhone13', quantity: 1, price: 5300),
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
                            Tag: 'Date',
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08,
                          ),
                          PaymentTag(
                            Tag: 'Amount',
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08,
                          ),
                          PaymentTag(
                            Tag: 'Status',
                          ),
                        ],
                      ),
                    ),
                    ReportsInstallmentsCard(
                        installments: 'Down Payment',
                        date: '03/04/22',
                        price: 5300,
                        status: "Paid"),
                    ReportsInstallmentsCard(
                        installments: '2nd EMI',
                        date: '03/04/22',
                        price: 1000,
                        status: "Due"),
                    Container(
                      height: 42,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top:
                                  BorderSide(color: Colors.black12, width: 0.3),
                              bottom: BorderSide(
                                  color: Colors.black12, width: 0.3))),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6.0, left: 26),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Text(
                                  'Updates',
                                  style: TextStyle(
                                      color: Color(0xffE96E2B),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10),
                                  textAlign: TextAlign.center,
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.08,
                            ),
                            Text(
                              '03/04/23',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 10),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.09,
                            ),
                            Text(
                              '\$1000',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 10),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Paid Less',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10),
                                ),
                                GestureDetector(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      color: Color(0xffE96E2B),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Emp_bottomAppBar(
        index: 2,
      ),
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

class CreditsLeft extends StatelessWidget {
  const CreditsLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.21,
      height: MediaQuery.of(context).size.height * 0.025,
      decoration: BoxDecoration(
        color: Color(0xfffdbbbb),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          CircleAvatar(
              radius: 5,
              backgroundColor: Color(0xffF94E4E),
              child: Icon(
                Icons.watch_later_outlined,
                color: Colors.white,
                size: 5,
              )),
          Text(
            "Credit left",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xffF94E4E)),
          ),
        ],
      ),
    );
  }
}

class NoDues extends StatelessWidget {
  const NoDues({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.16,
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
            "No Dues",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xff0e64e0)),
          ),
        ],
      ),
    );
  }
}

class Duesleft extends StatelessWidget {
  const Duesleft({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.025,
      decoration: BoxDecoration(
        color: Color(0xfffdbbbb),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          CircleAvatar(
              radius: 5,
              backgroundColor: Color(0xffF94E4E),
              child: Icon(
                Icons.watch_later_outlined,
                color: Colors.white,
                size: 5,
              )),
          Text(
            "Dues left",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xffF94E4E)),
          ),
        ],
      ),
    );
  }
}
