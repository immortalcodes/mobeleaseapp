import 'package:flutter/material.dart';
class Emp_Dropdown_Farm extends StatefulWidget {
  final String selectedValue;
  final ValueChanged<String> onValueChanged;

  Emp_Dropdown_Farm({required this.selectedValue, required this.onValueChanged});

  @override
  _Emp_Dropdown_FarmState createState() => _Emp_Dropdown_FarmState();
}

class _Emp_Dropdown_FarmState extends State<Emp_Dropdown_Farm> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedValue,
      onChanged: (String? newValue) {
        widget.onValueChanged(newValue!);
      },
      items: <String>[
        'Rosa Park',
        'Hudson Lane',
        'Sterlin Rd.',
        'Add New',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
            child: Item(value: value),
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

class Item extends StatefulWidget {
  String value='';
  Item({super.key, required this.value});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    if (widget.value == 'Add New') {
      return GestureDetector(
        onTap: (){},
        child: Row(
          children: [
            Text(widget.value, style: TextStyle(color: Color(0xffE96E2B), fontSize: 14)),
            Icon(Icons.add, color: Color(0xffE96E2B), size: 14),
          ],
        ),
      );
    } else {
      return Text(widget.value); // You should return the Text widget here
    }
  }
}
