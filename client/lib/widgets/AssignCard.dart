import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobelease/screens/Employee/Emp_Assign_1.dart';

class AssignCard extends StatefulWidget {
  late String model;
  late String quantity;
  late String company;
  bool isEmp;
  int? deviceId;
  MyModel? myModel;

  AssignCard(
      {required this.model,
      required this.quantity,
      required this.company,
      required this.isEmp,
      this.deviceId,
      this.myModel});
  @override
  _AssignCardState createState() => _AssignCardState();
}

class _AssignCardState extends State<AssignCard> {
  bool isSelected = true;

  int localQuantity = 0;
  Set<Map<String, dynamic>>? selecteditemCount = {};

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
              if (!(widget.isEmp))
                GestureDetector(
                  onTap: () {
                    if (localQuantity > 0)
                      setState(() {
                        localQuantity -= 1;
                      });
                    widget.myModel!
                        .updateLocalQnt(widget.deviceId!, localQuantity);
                  },
                  child: Icon(
                    Icons.remove_circle,
                    color: Color(0xffE96E2B),
                  ),
                ),
              widget.isEmp
                  ? Text(
                      widget.quantity,
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                    )
                  : Text(
                      "${localQuantity.toString()} / ${widget.quantity}",
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                    ),
              if (!(widget.isEmp))
                GestureDetector(
                  onTap: () {
                    if (localQuantity < int.parse(widget.quantity))
                      setState(() {
                        localQuantity += 1;
                      });
                    widget.myModel!
                        .updateLocalQnt(widget.deviceId!, localQuantity);
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
