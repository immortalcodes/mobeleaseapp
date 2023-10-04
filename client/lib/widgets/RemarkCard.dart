import 'dart:convert';

import 'package:flutter/material.dart';

class RemarkCard extends StatelessWidget {
  late String imgpath;
  late String name;
  late String remark;
  late String time;
  RemarkCard(
      {required this.imgpath,
      required this.name,
      required this.remark,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imgpath.isEmpty
                ? CircleAvatar(
                    radius: 26,
                    backgroundImage:
                        AssetImage("assets/svgs/no-profile-picture.png"),
                  )
                : CircleAvatar(
                    radius: 26,
                    backgroundImage: MemoryImage(
                      base64Decode(imgpath),
                    ),
                  ),
            SizedBox(
              width: 160.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  Text(remark,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff67727E))),
                ],
              ),
            ),
            Text(time,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff67727E)))
          ],
        ),
      ),
    );
  }
}
