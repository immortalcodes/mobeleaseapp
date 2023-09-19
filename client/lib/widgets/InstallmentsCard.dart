import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InstallmentsCard extends StatelessWidget {
  String installments='';
  String date="";
  double price=0;
  InstallmentsCard({required this.installments,required this.date,required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12, width: 0.3),bottom: BorderSide(color: Colors.black12, width: 0.3))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.2,
                child: Text(installments, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10),textAlign: TextAlign.center,)
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.2,
            ),
            Text(date, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.1,
            ),
            Text('\$$price', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),),
          ],
        ),
      ),
    );
  }
}
