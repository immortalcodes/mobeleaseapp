import 'package:flutter/material.dart';

class Emp_Dropdown_Language extends StatefulWidget {
  final String selectedValue;
  final ValueChanged<String> onValueChanged;

  Emp_Dropdown_Language(
      {required this.selectedValue, required this.onValueChanged});

  @override
  _Emp_Dropdown_LanguageState createState() => _Emp_Dropdown_LanguageState();
}

class _Emp_Dropdown_LanguageState extends State<Emp_Dropdown_Language> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      underline: Container(),
      value: widget.selectedValue,
      onChanged: (String? newValue) {
        widget.onValueChanged(newValue!);
      },
      items: <String>[
        'English',
        'Spanish',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      icon: Icon(
        Icons.keyboard_arrow_down_sharp,
        color: Color(0xffE96E2B),
      ),
      isExpanded: true,
      elevation: 0,
      style: TextStyle(color: Colors.grey),
    );
  }
}
