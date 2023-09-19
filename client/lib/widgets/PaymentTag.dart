import 'package:flutter/material.dart';

class PaymentTag extends StatelessWidget {
  String Tag='';
  PaymentTag({required this.Tag});

  @override
  Container build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xffF7EBE4), borderRadius: BorderRadius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(Tag, style: TextStyle(color: Color(0xffE96E2B), fontSize: 10, fontWeight: FontWeight.w600),),
      ),
    );
  }
}
