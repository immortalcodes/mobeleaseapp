import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:mobelease/widgets/Appbar.dart';
import 'package:mobelease/widgets/BottomAppBar.dart';

class ReportsScreen extends StatelessWidget {
  ReportsScreen({super.key});
  final AuthController authController = AuthController();
  Future<dynamic> getStatistics() async {
    final token = await authController.getToken();

    var url = Uri.parse('$baseUrl/sale/viewstats');

    var headers = {
      'accept': 'application/json',
      'Cookie': '${token}',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', url);

    request.body = json.encode(
        {"empid": 0, "starttime": "2021-09-15", "endtime": "2023-12-15"});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = jsonDecode(await response.stream.bytesToString());
      print(res);
      return res;
    } else {
      print(response.reasonPhrase);
    }
  }

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
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: getStatistics(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Placeholder for loading state
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    var stats = snapshot.data['data'];

                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reports",
                                style: TextStyle(
                                    fontSize: 20, color: Color(0xffE96E2B)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(255, 247, 218, 194),
                                  ),
                                  height: 60,
                                  width: 120,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 11,
                                              backgroundColor: Color.fromARGB(
                                                  255, 240, 123, 13),
                                              child: Icon(
                                                Icons.poll_rounded,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Total Sales",
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Text(
                                                '\$ ${stats['credit_totalsale']}'),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          Color.fromARGB(255, 217, 241, 218)),
                                  height: 60,
                                  width: 120,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 11,
                                              backgroundColor: Color.fromARGB(
                                                  255, 10, 170, 93),
                                              child: Icon(
                                                Icons.poll_rounded,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "COGS",
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Text('\$ ${stats['credit_cogs']}'),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(255, 201, 229, 243),
                                  ),
                                  height: 60,
                                  width: 120,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 11,
                                              backgroundColor: Color.fromARGB(
                                                  255, 23, 142, 240),
                                              child: Icon(
                                                Icons.poll_rounded,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Total credit left",
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Text('\$ ${stats['creditleft']}'),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(255, 233, 241, 186),
                                  ),
                                  height: 60,
                                  width: 120,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 11,
                                              backgroundColor: Color.fromARGB(
                                                  255, 174, 203, 10),
                                              child: Icon(
                                                Icons.poll_rounded,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Stolen loss",
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Text(
                                                '\$ ${stats['stolen_loss'] == null ? 0 : stats['stolen_loss']}'),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    );
                  }
                })
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBar(index: 2),
    );
  }
}
