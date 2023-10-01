import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  String hint;
  TextEditingController? controller;
  VoidCallback? fn;
  bool profileField;
  TextFieldWidget(
      {required this.hint,
      required this.controller,
      this.fn,
      required this.profileField});

  @override
  TextFormField build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        //labelText: 'Email',
        suffixIcon: profileField
            ? IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: fn,
              )
            : Text(""),
        hintText: hint,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(9.0),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.0),
            borderSide: BorderSide(
              color: Color(0xffE96E2B),
            )),
      ),
    );
  }
}
