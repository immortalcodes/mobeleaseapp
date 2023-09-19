import 'package:flutter/material.dart';
class MyDropdown extends StatefulWidget {
  final String selectedValue;
  final ValueChanged<String> onValueChanged;

  MyDropdown({required this.selectedValue, required this.onValueChanged});

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedValue,
      onChanged: (String? newValue) {
        widget.onValueChanged(newValue!);
      },
      items: <String>[
        'watch',
        'laptop',
        'glass',
        'case',
        'charger',
        'earphone',
        'speaker',
        'phone',
        'misc',
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