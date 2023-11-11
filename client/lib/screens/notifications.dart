import 'package:flutter/material.dart';
import '../widgets/NotificationsCard.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 11.0, left: 11.0, right: 11.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    image: AssetImage("assets/images/logo.png"),
                    width: 99.0,
                    height: 55.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 12.0,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 18.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        color: Color(0xFFE96E2B),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.31,
                        letterSpacing: 0.08,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Clear all',
                        style: TextStyle(
                          color: Color(0xFFE96E2B),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                          letterSpacing: 0.07,
                        ),
                      ),
                    ),
                  ]),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 17.0, vertical: 10),
                  child: NotificationsCard(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 17.0, vertical: 10),
                  child: NotificationsCard(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 17.0, vertical: 10),
                  child: NotificationsCard(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
