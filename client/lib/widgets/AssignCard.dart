import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mobelease/widgets/buttons.dart';

class AssignCard extends StatefulWidget {
  late String model;
  late String quantity;
  late String company;

  int? deviceId;

  AssignCard({
    required this.model,
    required this.quantity,
    required this.company,
    this.deviceId,
  });
  @override
  _AssignCardState createState() => _AssignCardState();
}

class _AssignCardState extends State<AssignCard> {
  bool isSelected = true;

  int localQuantity = 0;
  Set<Map<String, dynamic>>? selecteditemCount = {};
  @override
  void initState() {
    super.initState();
    localQuantity = int.parse(widget.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              SvgPicture.asset('assets/svgs/MobileTag.svg'),
              SizedBox(width: 20),
              Text(widget.model,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          Row(
            children: [
              Text(widget.company,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Quantity",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 2.50,
              ),
              SizedBox(
                width: 5.0,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    localQuantity -= 1;
                  });
                },
                child: Icon(
                  Icons.remove_circle,
                  color: Color(0xffE96E2B),
                ),
              ),
              Text(
                localQuantity.toString(),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    localQuantity += 1;
                  });
                },
                child: Icon(
                  Icons.add_circle,
                  color: Color(0xffE96E2B),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }
}
