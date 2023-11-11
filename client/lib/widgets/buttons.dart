import 'package:flutter/material.dart';

class BlackButton {
  late String buttonText;
  late double Width;
  late double Height;
  late double Radius;
  Function() onpress;

  BlackButton(
      {required this.buttonText,
      required this.Width,
      required this.Height,
      required this.Radius,
      required this.onpress});

  ElevatedButton buildBlackButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xffE96E2B),
          // elevation: 5.0,
          minimumSize: Size(Width, Height),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Radius))),
      onPressed: onpress,
      child: Text(
        buttonText,
        style: TextStyle(
            letterSpacing: 2, fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
  }
}
