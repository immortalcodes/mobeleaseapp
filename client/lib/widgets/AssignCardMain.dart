import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssignCardMain extends StatelessWidget {
  late String model;
  late String quantity;

  AssignCardMain({
    required this.model,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 47.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: Offset(0, 8),
            ),
          ],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                SvgPicture.asset('assets/svgs/MobileTag.svg'),
                SizedBox(
                  width: 15,
                ),
                Text(model,
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
            Row(
              children: [
                Text(
                  "Quantity:",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  quantity,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
