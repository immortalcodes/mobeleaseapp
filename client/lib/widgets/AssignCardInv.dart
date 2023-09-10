import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssignCardInv extends StatelessWidget {
  late String model;
  late int cost;
  AssignCardInv({required this.model, required this.cost});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset('assets/svgs/MobileTag.svg'),
          Text(model, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          //SizedBox(width: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Cost Price", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),
              SizedBox(width: 5.0,),
              Text("\$$cost", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),
              SizedBox(width: 5.0,),
              GestureDetector(
                onTap: (){
                },
                child: Icon(Icons.delete, color: Color(0xffE96E2B),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
