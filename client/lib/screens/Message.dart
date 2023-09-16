import 'package:flutter/material.dart';
import '../widgets/Appbar.dart';

class Message extends StatelessWidget {
  const Message({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 11.0, left: 11.0, right: 11.0, bottom: 5.0),
                      child: Appbar(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Color(0xffE96E2B),
                                    size: 16,
                                  )),
                              CircleAvatar(
                                radius: 26.0,
                                backgroundImage:
                                    AssetImage('assets/images/image1.jpg'),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Ashwin Jaiswal",
                                style: TextStyle(
                                    color: Color(0xffE96E2B),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.phone,
                                color: Color(0xffE96E2B),
                              )),
                        ],
                      ),
                    ),
                    ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Remark: Wonderfull App!! Though Somechanges are requiredWonderfull App!! Though Somechanges are requiredWonderfull App!! Though Somechanges are requiredWonderfull App!! Though Somechanges are requiredWonderfull App!! Though Somechanges are requiredWonderfull App!! Though Somechanges are required",
                                style: TextStyle(
                                    color: Color(0xff67727E),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "time : 2 min ago",
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 40.0, right: 18.0, top: 5.0, bottom: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Admin",
                                style: TextStyle(
                                    color: Color(0xffE96E2B),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Remark: Wonderfull App!! Though Somechanges are requiredWonderfull App!! Though Somechanges are requiredWonderfull App!! Though Somechanges are requiredWonderfull App!! Though Somechanges are requiredWonderfull App!! Though Somechanges are requiredWonderfull App!! Though Somechanges are required",
                                style: TextStyle(
                                    color: Color(0xff67727E),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "time : 2 min ago",
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: "Write message...",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.send_rounded,
                                  color: Color(0xffE96E2B),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
