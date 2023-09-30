import 'package:flutter/material.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import '../widgets/buttons.dart';
import '../widgets/Background.dart';
import '../widgets/TextFieldWidget.dart';
import 'Admin/Employee.dart';
import 'init_screen.dart';

class Login extends StatefulWidget {
  final String loginMember;
  const Login({required this.loginMember});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthController _authController = AuthController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = ' ';
  bool passwordVisible = false;

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill your details';
      });
      return;
    }

    final loginSuccess = await _authController.login(
        email, password, widget.loginMember.toLowerCase());

    if (loginSuccess) {
      if (widget.loginMember == "ADMIN") {
        print("Admin Login success");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Employee()),
            (Route<dynamic> route) => false);
      } else {
        print("Employee Login success");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const InitScreen()),
            (Route<dynamic> route) => false);
      }
      // Navigate to the next screen upon successful login
    } else {
      setState(() {
        _errorMessage = 'Login failed. Please check your credentials.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: Background().buildBackground(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                ),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //SizedBox(height: ,),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 250,
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 15.0,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter your email address",
                        ),
                        SizedBox(height: 10.0),
                        TextFieldWidget(
                            controller: _emailController,
                            hint: "Username or email Address"),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter your Password",
                        ),
                        SizedBox(height: 10.0),

                        TextField(
                          controller: _passwordController,
                          obscureText: !passwordVisible,
                          decoration: InputDecoration(
                            hintText: "Password",
                            helperText: _errorMessage,
                            helperStyle: TextStyle(color: Colors.red),
                            suffixIcon: IconButton(
                              icon: passwordVisible
                                  ? Icon(Icons.visibility,
                                      color: Color(0xffE96E2B))
                                  : Icon(
                                      Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                              onPressed: () {
                                setState(
                                  () {
                                    passwordVisible = !passwordVisible;
                                  },
                                );
                              },
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9.0),
                              borderSide: BorderSide(color: Color(0xffE96E2B)),
                            ),
                          ),
                        ),
                        // SizedBox(height: 2.0),
                        // Text(
                        //   _errorMessage,
                        //   style: TextStyle(color: Colors.red),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  BlackButton(
                          buttonText: '${widget.loginMember} LOGIN',
                          Width: 318.0,
                          Height: 54.0,
                          Radius: 9.0,
                          onpress: _login)
                      .buildBlackButton(),
                  if (widget.loginMember == "EMPLOYEE") ...[
                    Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(
                                loginMember: "ADMIN",
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Admin Login',
                          style: TextStyle(
                              color: Color(0xffE96E2B),
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/Emp_home');
                        },
                        child: const Text(
                          'Employee Login',
                          style: TextStyle(
                              color: Color(0xffE96E2B),
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
