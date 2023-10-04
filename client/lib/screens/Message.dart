import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import '../widgets/Appbar.dart';
import 'package:http/http.dart' as http;

class Message extends StatefulWidget {
  int? empId;
  String? empName;
  String? empImg;

  Message({super.key, this.empId, this.empName, this.empImg});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final AuthController authController = AuthController();

  Future<Map<String, dynamic>> fetchRemarksofEmployee() async {
    print("emid id: ${widget.empId}");
    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/emp/viewremarks');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({"empid": widget.empId}),
        headers: {'Cookie': token!, 'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            jsonDecode(response.body)!['data'];
        print("Hello $responseData");
        return responseData;
      } else {
        throw Exception('Failed to load employees');
      }

      // return employees;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRemarksofEmployee();
  }

  String formatTimestamp(String timestamp) {
    final now = DateTime.now();

    // Custom parsing function to extract date and time components
    final regex = RegExp(r'(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})');
    final match = regex.firstMatch(timestamp);

    if (match != null) {
      final dateTimeString = match.group(0);
      final dateTime = DateTime.parse(dateTimeString!);
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return "just now";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes} min ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
      } else if (difference.inDays < 30) {
        return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).round();
        return "$months month${months > 1 ? 's' : ''} ago";
      } else {
        final years = (difference.inDays / 365).round();
        return "$years year${years > 1 ? 's' : ''} ago";
      }
    }

    // Return an error message if parsing fails
    return "Invalid timestamp";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
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
                              widget.empImg!.isEmpty
                                  ? CircleAvatar(
                                      radius: 26,
                                      backgroundImage: AssetImage(
                                          "assets/svgs/no-profile-picture.png"),
                                    )
                                  : CircleAvatar(
                                      radius: 26,
                                      backgroundImage: MemoryImage(
                                        base64Decode(widget.empImg!),
                                      ),
                                    ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.empName!,
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
                    Container(
                      height: 520,
                      child: FutureBuilder(
                          future: fetchRemarksofEmployee(),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: SizedBox(
                                      height: 15,
                                      width: 15,
                                      child:
                                          CircularProgressIndicator())); // Placeholder for loading state
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              Map<String, dynamic> remarksData = snapshot.data!;

                              return ListView.builder(
                                  itemCount: remarksData.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    print(remarksData.length);
                                    final key =
                                        remarksData.keys.elementAt(index);
                                    final currentData = remarksData[key];
                                    final initiater = currentData['initiater'];
                                    final remarkEmployee =
                                        initiater == "employee"
                                            ? currentData['remark']
                                            : currentData['reply'];

                                    final remarkAdmin = initiater == "admin"
                                        ? currentData['remark']
                                        : currentData['reply'];

                                    final remarkTimeEmp =
                                        initiater == "employee"
                                            ? formatTimestamp(
                                                currentData['remarktimestamp'])
                                            : formatTimestamp(
                                                currentData['replytimestamp']);

                                    final remarkTimeAdmin = initiater == "admin"
                                        ? formatTimestamp(
                                            currentData['remarktimestamp'])
                                        : formatTimestamp(
                                            currentData['replytimestamp'] ??
                                                "");
                                    return Column(
                                      children: [
                                        remarkEmployee != null
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 30.0,
                                                        vertical: 5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      remarkEmployee,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff67727E),
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Text(remarkTimeEmp,
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffE96E2B))),
                                                  ],
                                                ),
                                              )
                                            : Text(""),
                                        remarkAdmin != null
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 80.0,
                                                    right: 18.0,
                                                    top: 8.0,
                                                    bottom: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Text(
                                                      "Admin",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffE96E2B),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 13),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          remarkAdmin,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff67727E),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        Text(remarkTimeAdmin,
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xffE96E2B))),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Text(""),
                                      ],
                                    );
                                  });
                            }
                          })),
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
