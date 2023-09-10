import 'package:flutter/material.dart';

class Background {
  const Background();

  @override
  BoxDecoration buildBackground() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/homebg.png"),
        opacity: 0.05,
        fit: BoxFit.fill,
      ),
    );
  }
}
