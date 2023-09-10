import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssignCard extends StatefulWidget {
  late String model;
  late int cost;
  AssignCard({required this.model, required this.cost});
  @override
  _AssignCardState createState() => _AssignCardState();
}
class _AssignCardState extends State<AssignCard> {


  var _count=0;

  // String get model => "model";
  void _incrementCounter() {
    setState(() {
      _count++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _count--;
    });
  }

  @override
  Container build(BuildContext context) {
    return Container(
      height: 47.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset('assets/svgs/MobileTag.svg'),
          Text(widget.model, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          //SizedBox(width: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Cost Price", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),
              SizedBox(width: 5.0,),
              Text("\$${widget.cost}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),
              SizedBox(width: 5.0,),
              GestureDetector(
                onTap: (){
                  _decrementCounter();
                },
                  child: Icon(Icons.remove_circle, color: Color(0xffE96E2B),),
                ),
              Text("$_count", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),),
              GestureDetector(
                onTap: (){
                  _incrementCounter();
                },
                  child: Icon(Icons.add_circle, color: Color(0xffE96E2B),),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

