import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssignCardInv extends StatelessWidget {
  late String model;
  String? company;
  late String cost;
  final Function onDelete;
  final int deviceId;
  String? storage;

  AssignCardInv({
    required this.model,
    required this.cost,
    required this.company,
    required this.onDelete,
    required this.deviceId,
    this.storage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset('assets/svgs/MobileTag.svg'),
          Text(company!,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          Text(model,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          Text("Storage: $storage",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),

          //SizedBox(width: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "\$$cost",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 5.0,
              ),
              GestureDetector(
                onTap: () {
                  onDelete(deviceId);
                },
                child: Icon(
                  Icons.delete,
                  color: Color(0xffE96E2B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
