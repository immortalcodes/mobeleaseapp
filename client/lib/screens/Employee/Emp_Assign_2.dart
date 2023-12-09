import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobelease/screens/Employee/PaymentCash.dart';
import 'package:mobelease/screens/Employee/PaymentCredit.dart';
import 'package:mobelease/screens/Employee/Emp_Dropdown_Unit.dart';
import 'package:mobelease/widgets/categories.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/Emp_Dropdown_Farm.dart';
import '../../widgets/Emp_Dropdown_Language.dart';
import 'package:image_picker/image_picker.dart';

class Emp_Assign_2 extends StatefulWidget {
  final Set<Map<String, dynamic>> isSelectedItems;
  const Emp_Assign_2({super.key, required this.isSelectedItems});

  @override
  State<Emp_Assign_2> createState() => _Emp_Assign_2State();
}

class _Emp_Assign_2State extends State<Emp_Assign_2> {
  String? firstName = " ";
  String? lastName = " ";
  String? phoneNo = " ";
  String? unit = " ";
  String selectedValue_Language = 'English';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _firstnameController = TextEditingController(text: '');
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  void updateSelectedValue_Language(String value) {
    setState(() {
      selectedValue_Language = value;
    });
  }

  XFile? _imageFile;

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }

  List<String> farmUnitList = [];
  String farmName = "";
  String selectedFarmunit = "";

  void updateSelectedValue_farmunit(String value) {
    setState(() {
      selectedFarmunit = value;
    });
  }

  void onSelectFarmtoFarrmUnit(
      List<String> selectedFarmList, String selectedFarmName) {
    setState(() {
      farmUnitList = selectedFarmList;
      farmName = selectedFarmName;
    });
    print("hello $farmUnitList $farmName");
  }

  String selectedCategory = 'Credit';
  var encodedImage;
  void _submitForm() async {
    print("jdkdkd ${widget.isSelectedItems}");
    if (_formKey.currentState!.validate()) {
      final String firstname = _firstnameController.text;
      final String lastname = _lastnameController.text;
      final String phoneno = _phoneController.text;
      if (_imageFile != null) {
        final imageBytes = await _imageFile!.readAsBytes();
        encodedImage = base64Encode(imageBytes);
        print(encodedImage);
      }
      if (firstname.isNotEmpty &&
          lastname.isNotEmpty &&
          phoneno.isNotEmpty &&
          farmName.isNotEmpty &&
          _imageFile.toString().isNotEmpty) {
        if (selectedCategory == 'Credit') {
          String name = "$firstname $lastname";
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentCredit(
                isSelectedItems: widget.isSelectedItems,
                cName: name,
                cPhoneno: phoneno,
                cAlert: forAlert,
                cImage: encodedImage,
                cUnit: selectedFarmunit,
                cFarm: farmName,
                clangauge: selectedValue_Language,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please fill all details!"),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  bool forAlert = false;
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentCash(
                                    isSelectedItems: widget.isSelectedItems,
                                  ),
                                ),
                              );

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
                                    farmName: farmName,
                                    onSelectFarmUnit:
                                        updateSelectedValue_farmunit,
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
                                      onPressed: _getImage,
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
                            _imageFile != null
                                ? Image.file(
                                    File(_imageFile!.path),
                                    height: 150,
                                    width: 150,
                                  )
                                : Container(),
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
                              Switch(
                                // thumb color (round icon)
                                activeColor: Colors.blueGrey.shade600,
                                activeTrackColor: Colors.grey.shade400,
                                inactiveThumbColor: Colors.blueGrey.shade600,
                                inactiveTrackColor: Colors.grey.shade400,
                                splashRadius: 50.0,

                                value: forAlert,
                                // changes the state of the switch
                                onChanged: (value) {
                                  setState(() => forAlert = value);
                                  print(value);
                                },
                              ),
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
                                minimumSize: Size(107, 25),
                                textStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0))),
                            onPressed: _submitForm,
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
