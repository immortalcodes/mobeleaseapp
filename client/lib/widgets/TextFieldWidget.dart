import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  String hint;
  TextEditingController? controller;
  TextFieldWidget({required this.hint,required this.controller});

  @override
  TextFormField build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: true,
      decoration: InputDecoration(
        //labelText: 'Email',
        hintText: hint,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(9.0),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.0),
            borderSide: BorderSide(
              color: Color(0xffE96E2B),
            )
        ),

      ),
    );
  }
}