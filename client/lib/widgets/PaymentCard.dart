import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentCard extends StatelessWidget {
  String item='';
  int quantity=0;
  double price=0;
  double total = 0;
  PaymentCard({required this.item,required this.quantity,required this.price,required this.total});

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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.16,
                child: Text(item, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10),textAlign: TextAlign.center)
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.2,
            ),
            Text('$quantity', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.1,
            ),
            Row(
              children: [
                Text('\$$price', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),),
                SvgPicture.asset('assets/svgs/pen.svg', width: 10,color: Color(0xffE96E2B)),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.05,
            ),
            Text('\$$total', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10),),
          ],
        ),
      ),
    );
  }
}
