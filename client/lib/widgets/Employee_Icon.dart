import 'package:flutter/material.dart';

class Employee_icon extends StatelessWidget {
  late String imagePath;

  Employee_icon({ required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, '/EmployeePersonal');
        },
        child: SizedBox(
          width: 49.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24.5,
                backgroundImage: AssetImage(imagePath),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
