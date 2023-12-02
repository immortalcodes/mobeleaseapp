import 'package:flutter/material.dart';

class SaleDetailsCard extends StatelessWidget {
  String itemName;
  int quantity;
  int sellprice;
  SaleDetailsCard(
      {super.key,
      required this.itemName,
      required this.quantity,
      required this.sellprice});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: Colors.black12, width: 0.3),
              bottom: BorderSide(color: Colors.black12, width: 0.3))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.16,
                child: Text(itemName,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
                    textAlign: TextAlign.center)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            Text(
              '$quantity',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            Text(
              '\$ $sellprice',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            Text(
              '\$ ${quantity * sellprice}',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
