import 'package:flutter/material.dart';
import 'package:mobelease/widgets/Emp_bottomAppBar.dart';
import 'package:mobelease/widgets/EmployeeDataCard.dart';

import '../../widgets/Appbar.dart';

class Emp_Reports_1 extends StatefulWidget {
  const Emp_Reports_1({super.key});

  @override
  State<Emp_Reports_1> createState() => _Emp_Reports_1State();
}

List<String> dates = ['03/02/23', '03/04/23'];
List<EmployeeDataCard> datacard = [
  EmployeeDataCard(
    cost: 500,
    date: dates[0],
    name: 'SRS',
    cash: true,
    paid: true,
  ),
  EmployeeDataCard(
    cost: 500,
    date: dates[1],
    name: 'SRS',
    cash: true,
    paid: true,
  ),
  EmployeeDataCard(
    cost: 500,
    date: dates[0],
    name: 'SRS',
    cash: true,
    paid: true,
  ),
  EmployeeDataCard(
    cost: 500,
    date: dates[1],
    name: 'SRS',
    cash: true,
    paid: true,
  ),
  EmployeeDataCard(
    cost: 500,
    date: dates[0],
    name: 'SRS',
    cash: true,
    paid: true,
  ),
  EmployeeDataCard(
    cost: 500,
    date: dates[1],
    name: 'SRS',
    cash: true,
    paid: true,
  ),
  EmployeeDataCard(
    cost: 500,
    date: dates[0],
    name: 'SRS',
    cash: true,
    paid: true,
  ),
  EmployeeDataCard(
    cost: 500,
    date: dates[1],
    name: 'SRS',
    cash: true,
    paid: true,
  ),
];

class _Emp_Reports_1State extends State<Emp_Reports_1> {
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
              child: Text("Past Orders",
                  style: TextStyle(
                      color: Color(0xffE96E2B),
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0)),
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount:
                      datacard.length, // The number of items in your list
                  itemBuilder: (BuildContext context, int index) {
                    datacard.sort((b, a) => a.date.compareTo(b.date));

                    final cardData = datacard[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/Reports');
                          },
                          child: EmployeeDataCard(
                            cost: cardData.cost,
                            date: cardData.date,
                            name: cardData.name,
                            cash: cardData.cash,
                            paid: cardData.paid,
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
