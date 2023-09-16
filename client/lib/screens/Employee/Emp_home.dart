import 'package:flutter/material.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/EmployeeDataCard.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Emp_home extends StatefulWidget {
  const Emp_home({super.key});

  @override
  State<Emp_home> createState() => _Emp_homeState();
}

class _Emp_homeState extends State<Emp_home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
              const EdgeInsets.only(top: 11.0, left: 11.0, right: 11.0),
              child: Appbar(),
            ),
            SizedBox(height: 100,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36.0),
              child: GestureDetector(
                onTap: (){},
                child: Container(
                  width: 167,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Color(0xffE96E2B), width: 0.5),
                    color: Color(0xffFFF7ED)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset(
                          'assets/svgs/ShoppingCart.svg',  // Replace with your SVG file path
                          // semanticsLabel: 'A red up arrow'
                      ),

                      // SvgPicture("assets/svgs/ShoppingCart.svg"),
                      Row(
                        children: [
                          Text('Sell Devices', style: TextStyle( color: Color(0xffE96E2B), fontSize: 14 , fontWeight: FontWeight.w600),),
                          Icon(Icons.arrow_right_alt, color: Color(0xffE96E2B), size: 13,)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0, horizontal: 13.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Recent Selling", style: TextStyle(color: Color(0xffE96E2B), fontSize: 14, fontWeight: FontWeight.w600 )),
                  SizedBox(height: 8,),
                  EmployeeDataCard(cost: 4500, date: '03/03/20232', name: "Ashwin Jaiswal", cash: true, paid: true, dues: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
