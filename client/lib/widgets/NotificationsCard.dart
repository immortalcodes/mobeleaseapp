import 'package:flutter/material.dart';

class NotificationsCard extends StatelessWidget {
  const NotificationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.only(top: 14.0, left: 3, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
                backgroundColor: Color(0xFFE96E2B),
                child: Icon(Icons.notifications, color: Colors.white,)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.65,
                  child: Text(
                    softWrap: true,
                    "Lorem ipsum dolor sit amet, consectetur  elit sit amet.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
                ),
                Text("1min ago", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6C6C6C)),)
              ],
            ),
            Icon(Icons.close, color: Colors.grey)
          ],
        ),
      ),
    );
  }
}

