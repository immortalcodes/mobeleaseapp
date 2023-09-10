import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuickStyle extends StatelessWidget {
  final String title;
  final String svgPath;
  final String Context;
  final colorhex;

  QuickStyle({required this.title, required this.svgPath, required this.Context, required this.colorhex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, Context);
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 24.0,
              backgroundColor: Color(colorhex),
              child: SvgPicture.asset(
                svgPath, alignment: Alignment.center,
              ),
            ),
            SizedBox(height: 5.0,),
            Text(title, textAlign: TextAlign.justify, style: TextStyle(fontSize: 11.0),)
          ],
        ),
      ),
    );
  }
}
