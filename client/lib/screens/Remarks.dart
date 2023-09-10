import 'package:flutter/material.dart';
import 'package:mobelease/widgets/RemarkCard.dart';
import '../widgets/Appbar.dart';
import '../widgets/BottomAppBar.dart';

class Remarks extends StatefulWidget {
  const Remarks({super.key});

  @override
  State<Remarks> createState() => _RemarksState();
}

class _RemarksState extends State<Remarks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 11.0,left: 11.0,right: 11.0),
              child: Appbar(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 23.0,bottom: 16.0,left: 18.0,right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Remarks", style: TextStyle(color: Color(0xffE96E2B), fontWeight: FontWeight.w600, fontSize: 16.0 )),
                  GestureDetector(
                    onTap: (){

                    },
                    child: Icon(Icons.add_circle, color: Color(0xffE96E2B),size: 16.0,),
                    ),
                ],
              ),
            ),
            for(var i=0;i<4;i++)
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/Message');
                },
                  child: RemarkCard(imgpath: 'assets/images/image1.jpg', name: 'Ashwin Jaiswal', remark: 'Wonderfull App!! Though Somechanges are required', time: '2 minn ago'))
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBar(),
    );
  }
}
