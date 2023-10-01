import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class Employee_icon extends StatelessWidget {
  String imagePath;

  Employee_icon({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        width: 49.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imagePath.isEmpty
                ? CircleAvatar(
                    radius: 24.5,
                    backgroundImage:
                        AssetImage("assets/svgs/no-profile-picture.png"),
                  )
                : CircleAvatar(
                    radius: 24.5,
                    backgroundImage: MemoryImage(
                      base64Decode(imagePath),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
