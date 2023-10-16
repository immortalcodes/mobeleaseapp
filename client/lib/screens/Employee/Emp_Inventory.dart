import 'package:flutter/material.dart';
import 'package:mobelease/widgets/AssignCard.dart';
import 'package:mobelease/widgets/categories.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/Emp_bottomAppBar.dart';
import '../../widgets/buttons.dart';

class Emp_Inventory extends StatefulWidget {
  const Emp_Inventory({super.key});

  @override
  State<Emp_Inventory> createState() => _Emp_InventoryState();
}

class _Emp_InventoryState extends State<Emp_Inventory> {
  String selectedCategory = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 11.0, left: 11.0, right: 11.0),
              child: Appbar(),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 23.0, left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(
                        color: Color(0xffE96E2B),
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Categories(
                            title: 'phone',
                            svgpath: "assets/svgs/Mobile.svg",
                            onpress: () {
                              setState(() {
                                selectedCategory =
                                    'phone'; // Update the selected category
                              });
                            },
                            selectedCategory: selectedCategory)
                        .buildCategories(),
                  ]),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    child: AssignCard(
                      model: "Redmi 11i Pro",
                      company: "",
                      quantity: '0',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Emp_bottomAppBar(
        index: 1,
      ),
    );
  }
}
