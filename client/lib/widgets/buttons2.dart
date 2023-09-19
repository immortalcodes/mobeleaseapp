import 'package:flutter/material.dart';

class WhiteOrangeButton {
  late String buttonText;
  Function() onpress;

  WhiteOrangeButton({required this.buttonText, required this.onpress});

  ElevatedButton buildWhiteOrangeButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xffF4E8E1),
          // elevation: 5.0,
          minimumSize: Size(160, 40),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      onPressed: onpress,
      child: Text(
        buttonText,
        style: TextStyle(color:Color(0xffE96E2B),letterSpacing: 2,fontSize: 15,fontWeight: FontWeight.w700),
      ),
    );
  }
}
