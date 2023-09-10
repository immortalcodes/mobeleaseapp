import 'package:flutter/material.dart';
import 'package:mobelease/widgets/TextFieldWidget2.dart';
import '../../models/Inventory_Model.dart';
import '../../widgets/TextFieldWidget.dart';
import '../../widgets/TextFieldWidget2.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class AddDeviceDialog extends StatefulWidget {
  const AddDeviceDialog({super.key});

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _CompanyController = TextEditingController();
  @override
  AlertDialog build(BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Add a new device", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xffE96E2B)),),
              CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey[400],
                  child: IconButton(onPressed: (){}, icon: Icon(Icons.close, size: 13, color: Colors.black))),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Select Category"),
                          SizedBox(height: 5,),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,),
                                borderRadius: BorderRadius.circular(9)
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MyDropdown(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Company"),
                          SizedBox(height: 5,),
                          TextFieldWidget(
                              hint: '',
                              controller: _CompanyController,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Device Name"),
                          SizedBox(height: 5,),
                          TextFieldWidget(
                            hint: '',
                            controller: _CompanyController,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Storage"),
                          SizedBox(height: 5,),
                          TextFieldWidget(
                            hint: '',
                            controller: _CompanyController,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Cost Price"),
                          SizedBox(height: 5,),
                          TextFieldWidget(
                            hint: '',
                            controller: _CompanyController,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
        style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xffE96E2B),),
                child: const Text("SUBMIT",),
                onPressed: () {
                  // your code
                },
              ),
            ),
          ],
        );
  }
}
class MyDropdown extends StatefulWidget {
  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String selectedValue = 'Watch'; // Default selected value

  @override
  DropdownButton build(BuildContext context) {
    return DropdownButton<String>(
          value: selectedValue,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
            });
          },
          items: <String>[
            'Watch',
            'Laptop',
            'Glass',
            'Case',
            'Charger',
            'Earphone',
            'Speaker',
            'Phone',
            'Misc',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          icon: Icon(Icons.keyboard_arrow_down_sharp, color: Color(0xffE96E2B),),
          isExpanded: true,
          elevation: 0,
      style: TextStyle(color: Colors.grey),
        );
  }
}