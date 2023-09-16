import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssignCard extends StatefulWidget {
  late String model;
  late String storage;
  final ValueChanged<int> onQuantityChanged;
  AssignCard({required this.model, required this.storage,required this.onQuantityChanged});
  @override
  _AssignCardState createState() => _AssignCardState();
}
class _AssignCardState extends State<AssignCard> {


  var _count=1;

  // String get model => "model";
  void _incrementCounter() {
    setState(() {
      _count++;
      widget.onQuantityChanged(_count);
    });
  }

  void _decrementCounter() {
    setState(() {
      _count--;
      widget.onQuantityChanged(_count);
    });
  }

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
            offset: Offset(0,8),
          ),
        ],
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
              Text("Cost:", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),
              SizedBox(width: 2.50,),
              Text("\$${widget.storage}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),
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

