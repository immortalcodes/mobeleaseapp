import 'package:flutter/material.dart';
import 'package:mobelease/widgets/AssignCard.dart';
import 'package:mobelease/widgets/categories.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/buttons.dart';

class Emp_Assign_1 extends StatefulWidget {
  const Emp_Assign_1({super.key});

  @override
  State<Emp_Assign_1> createState() => _Emp_Assign_1State();
}

class _Emp_Assign_1State extends State<Emp_Assign_1> {
  String selectedCategory = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.only(top: 11.0, left: 11.0, right: 11.0),
              child: Appbar(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 23.0,bottom: 16.0,left: 18.0,right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Select Devices", style: TextStyle(color: Color(0xffE96E2B), fontWeight: FontWeight.w600, fontSize: 20.0 )),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 12.0,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.close, color: Colors.black,),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 18.0, vertical: 7.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xffE96E2B),
                  ),
                  hintText: "Search Devices",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9.0),
                    borderSide: BorderSide(color: Color(0xffE96E2B)),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Categories(
                      title: 'phone',
                      svgpath: "assets/svgs/Mobile.svg",
                      onpress: () {
                        setState(() {
                          selectedCategory =
                              'phone'; // Update the selected category
                        });
                      },
                      selectedCategory: selectedCategory).buildCategories(),
                ]
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
                    child: AssignCard(
                      model: "Redmi 11i Pro",
                      storage: '0',
                      onQuantityChanged: (newquantity){

                      },
                    ),
                  );
                },
              ),
            ),
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 8,top: 6),
                    height: MediaQuery.of(context).size.height*0.055,
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Seel All selected Devices", style: TextStyle(color: Color(0xffE96E2B), fontWeight: FontWeight.w500, fontSize: 13),),
                    ),
                  ),
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
                    height: MediaQuery.of(context).size.height*0.1,
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("5 items Selected", style: TextStyle(color: Color(0xff474747), fontSize: 13.0)),
                            ]
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffE96E2B),
                                // elevation: 5.0,
                                minimumSize: Size(107, 25),
                                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                            onPressed: (){
                              Navigator.pushNamed(context, '/Emp_Assign_2');
                            },
                            child: Text(
                              "Enter Customer details",
                              style: TextStyle(letterSpacing: 2,fontSize: 12,fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
