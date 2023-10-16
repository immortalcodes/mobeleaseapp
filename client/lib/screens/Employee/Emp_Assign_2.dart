import 'package:flutter/material.dart';
import 'package:mobelease/screens/Employee/Emp_Dropdown_Unit.dart';

import 'package:mobelease/widgets/categories.dart';
import '../../widgets/Appbar.dart';

import '../../widgets/Emp_Dropdown_Farm.dart';
import '../../widgets/Emp_Dropdown_Language.dart';
import '../../widgets/TextFieldWidget.dart';
import '../../widgets/TextFieldWidget2.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Emp_Assign_2 extends StatefulWidget {
  const Emp_Assign_2({super.key});

  @override
  State<Emp_Assign_2> createState() => _Emp_Assign_2State();
}

String? firstName = " ";
String? lastName = " ";
String? phoneNo = " ";
String? unit = " ";
String selectedValue_Language = 'English';
String selectedValue_Farm = 'Rosa Park';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController _firstnameController = TextEditingController(text: '');
TextEditingController _lastnameController = TextEditingController();
TextEditingController _phoneController = TextEditingController();
TextEditingController _unitController = TextEditingController();

class _Emp_Assign_2State extends State<Emp_Assign_2> {
  void updateSelectedValue_Language(String value) {
    setState(() {
      selectedValue_Language = value;
    });
  }

  void updateSelectedValue_Farm(String value) {
    setState(() {
      selectedValue_Farm = value;
    });
  }

  List<String> farmUnitList = [];
  String farmName = "";
  void onSelectFarmtoFarrmUnit(
      List<String> selectedFarmList, String selectedFarmName) {
    setState(() {
      farmUnitList = selectedFarmList;
      farmName = selectedFarmName;
    });
    print("hello $farmUnitList $farmName");
  }

  String selectedCategory = 'Credit';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Customer Details",
                      style: TextStyle(
                          color: Color(0xffE96E2B),
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0)),
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      "Payment Mode",
                      style: TextStyle(
                          color: Color(0xffE96E2B),
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Categories(
                            title: 'Credit',
                            svgpath: "",
                            onpress: () {
                              setState(() {
                                selectedCategory =
                                    'Credit'; // Update the selected category
                              });
                            },
                            selectedCategory: selectedCategory)
                        .buildCategories(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Categories(
                            title: 'Cash',
                            svgpath: "",
                            onpress: () {
                              setState(() {
                                selectedCategory =
                                    'Cash'; // Update the selected category
                              });
                            },
                            selectedCategory: selectedCategory)
                        .buildCategories(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 17.0, vertical: 12),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.all(8.0),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.42,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("First Name"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  // TextEditingController()
                                  SizedBox(
                                      height: 44,
                                      child: TextFormField(
                                        controller: _firstnameController,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(9.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                              borderSide: BorderSide(
                                                color: Color(0xffE96E2B),
                                              )),
                                          hintText: "Name",
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.42,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Last Name"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                      height: 44,
                                      child: TextFormField(
                                        controller: _lastnameController,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(9.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                              borderSide: BorderSide(
                                                color: Color(0xffE96E2B),
                                              )),
                                          hintText: "Name",
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Phone Number"),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                                height: 44,
                                child: TextFormField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(9.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: BorderSide(
                                          color: Color(0xffE96E2B),
                                        )),
                                    hintText: "+184678xxxx",
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Language"),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 44,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(9)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Emp_Dropdown_Language(
                                    selectedValue: selectedValue_Language,
                                    onValueChanged:
                                        updateSelectedValue_Language,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Farm"),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 44,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(9)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Emp_Dropdown_Farm(
                                    onSelectFarm: onSelectFarmtoFarrmUnit,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Unit"),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 44,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(9)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Emp_Dropdown_Unit(
                                      farmunitList: farmUnitList,
                                      farmName: farmName),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Customer ID"),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                                height: 44,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.camera_alt),
                                      onPressed: () {},
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(9.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        borderSide: BorderSide(
                                          color: Color(0xffE96E2B),
                                        )),
                                    hintText: "docs.pdf",
                                  ),
                                )),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Text(
                                "Alert",
                                style: TextStyle(color: Color(0xffE96E2B)),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xffE96E2B),
                                    onPrimary: Colors.white,
                                    minimumSize: Size(65, 26),
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text("Alert"))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
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
                                Text("5 items Selected",
                                    style: TextStyle(
                                        color: Color(0xff474747),
                                        fontSize: 13.0)),
                              ]),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffE96E2B),
                                // elevation: 5.0,
                                minimumSize: Size(107, 25),
                                textStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0))),
                            onPressed: () {
                              if (selectedCategory == 'Credit') {
                                Navigator.pushNamed(context, '/PaymentCredit');
                              } else {
                                Navigator.pushNamed(context, '/PaymentCash');
                              }
                            },
                            child: Text(
                              "Proceed to pay",
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
          ],
        ),
      ),
    );
  }
}
