import 'package:flutter/material.dart';

class TextFieldWidget2 extends StatelessWidget {
  String hint;
  // String? initialValue;
  TextEditingController? controller = TextEditingController();
  TextFieldWidget2({required this.hint, required this.controller});

  @override
  TextFormField build(BuildContext context) {
    return TextFormField(
      controller: controller,
      // initialValue: initialValue,
      // enabled: false,
      autofocus: true,
      decoration: InputDecoration(
        //labelText: 'Email',
        hintText: hint,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 1, color: Colors.transparent)),
        // disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1),borderRadius: BorderRadius.circular(9.0),),
      ),
    );
  }
}
