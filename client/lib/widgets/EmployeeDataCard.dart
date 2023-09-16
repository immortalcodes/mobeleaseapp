import 'package:flutter/material.dart';
import 'package:mobelease/widgets/buttons.dart';
import '../widgets/buttons.dart';

class EmployeeDataCard extends StatefulWidget {
  late double cost;
  late String date;
  late String name;
  late bool cash;
  late bool paid;
  late bool dues;

  EmployeeDataCard({required this.cost,required this.date,required this.name,required this.cash,required this.paid,required this.dues});

  @override
  State<EmployeeDataCard> createState() => _EmployeeDataCardState();
}

class _EmployeeDataCardState extends State<EmployeeDataCard> {

   PaymentType(){
    return widget.cash?Cash():Credit();
  }
    IsPaid(){
     return widget.paid?Paid():CreditsLeft();
   }
   Dues(){
     return widget.cash?Duesleft():NoDues();
   }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 73.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0,8),
          ),
        ],
      ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('\$${widget.cost}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                      SizedBox(width: 5,),
                      PaymentType(),
                    ],
                  ),
                  Text('${widget.date} \- ${widget.name}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),)
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [IsPaid(),
                      SizedBox(width: 5,),
                      Dues(),],
                  ),
                  SizedBox(
            height: 25,
            width: 120,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffE96E2B),
                  // elevation: 5.0,
                  minimumSize: Size(87, 25),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
              onPressed: (){},
              child: Text(
                "ADD REMARK",
                style: TextStyle(letterSpacing: 2,fontSize: 10.5,fontWeight: FontWeight.w700),
              ),
            ),
          ),
                ],
              )
            ],
          ),
        ),
    );
  }
}

class Cash extends StatelessWidget {
  const Cash({super.key});

  @override
  Container build(BuildContext context) {
    return Container(
      width: 35,
      height: 15,
      decoration: BoxDecoration(
        color: Color(0xffD2FDE6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text("Cash",textAlign: TextAlign.center, style: TextStyle(color: Color(0xff00974F)),),
    );
  }
}
class Credit extends StatelessWidget {
  const Credit({super.key});

  @override
  Container build(BuildContext context) {
    return Container(
      width: 45,
      height: 15,
      decoration: BoxDecoration(
        color: Color(0xffFFF5CA),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text("Credit",textAlign: TextAlign.center, style: TextStyle(color: Color(0xffF17400)),),
    );
  }
}

class Paid extends StatelessWidget {
  const Paid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 15,
      decoration: BoxDecoration(
        color: Color(0xff8fb4e7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 5,
              backgroundColor: Color(0xff116ef3),
              child: Icon(Icons.done, color: Colors.white, size: 5,)),
          Text("Paid",textAlign: TextAlign.center, style: TextStyle(color: Color(
              0xff0e64e0)),),
        ],
      ),
    );
  }
}
class CreditsLeft extends StatelessWidget {
  const CreditsLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 15,
      decoration: BoxDecoration(
        color: Color(0xfffdbbbb),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          CircleAvatar(
              radius: 5,
              backgroundColor: Color(0xffF94E4E),
              child: Icon(Icons.watch_later_outlined, color: Colors.white, size: 5,)),
          Text("Credit left",textAlign: TextAlign.center, style: TextStyle(color: Color(0xffF94E4E)),),
        ],
      ),
    );
  }
}
class NoDues extends StatelessWidget {
  const NoDues({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 15,
      decoration: BoxDecoration(
        color: Color(0xff8fb4e7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          CircleAvatar(
              radius: 5,
              backgroundColor: Color(0xff116ef3),
              child: Icon(Icons.done, color: Colors.white, size: 5,)),
          Text("No Dues",textAlign: TextAlign.center, style: TextStyle(color: Color(
              0xff0e64e0)),),
        ],
      ),
    );
  }
}
class Duesleft extends StatelessWidget {
  const Duesleft({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 15,
      decoration: BoxDecoration(
        color: Color(0xfffdbbbb),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          CircleAvatar(
              radius: 5,
              backgroundColor: Color(0xffF94E4E),
              child: Icon(Icons.watch_later_outlined, color: Colors.white, size: 5,)),
          Text("Dues left",textAlign: TextAlign.center, style: TextStyle(color: Color(0xffF94E4E)),),
        ],
      ),
    );
  }
}