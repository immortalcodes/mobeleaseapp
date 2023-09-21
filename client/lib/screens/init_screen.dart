import 'package:flutter/material.dart';
import 'package:mobelease/screens/login.dart';
import '../widgets/buttons_second.dart';
import '../widgets/buttons.dart';
import '../widgets/background.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: Background().buildBackground(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 70.0),
              Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Image.asset('assets/images/logo.png')]),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffE96E2B),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                              'Experience a better version of databse management'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  BlackButton(
                      buttonText: 'EMPLOYEE',
                      Width: 160.0,
                      Height: 40.0,
                      Radius:4.0,
                      onpress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(loginMember: 'EMPLOYEE'),
                          ),
                        );
                      }).buildBlackButton(),
                  SizedBox(
                    width: 10,
                  ),
                  WhiteOrangeButton(
                      buttonText: 'ADMIN',
                      onpress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(loginMember: 'ADMIN'),
                          ),
                        );
                      }).buildWhiteOrangeButton(),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}