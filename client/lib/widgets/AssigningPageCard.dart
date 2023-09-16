import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssigningPageCard extends StatelessWidget {
  late String model;
  late String cost;
  late String Storage;
  final int deviceId;
  Function() onTap;
  AssigningPageCard ({required this.model, required this.cost,required this.deviceId, required this.onTap, required this.Storage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 47.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: Offset(0,8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset('assets/svgs/MobileTag.svg'),
            Text(model, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Cost Price", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),
                SizedBox(width: 5.0,),
                Text("\$$cost", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),
                SizedBox(width: 5,),
                Text("Storage:", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),
                SizedBox(width: 5.0,),
                Text(Storage, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
