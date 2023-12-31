import 'package:flutter/material.dart';
import 'package:mobelease/controllers/employee_controller.dart';
import 'package:mobelease/screens/Admin/AssigningPage.dart';

import 'package:mobelease/screens/Employee/Emp_Assign_2.dart';
import 'package:mobelease/screens/Employee/Emp_Inventory.dart';
import 'package:mobelease/screens/Employee/Emp_Reports_1.dart';
import 'package:mobelease/screens/Employee/Emp_home.dart';
import 'package:mobelease/screens/Employee/PaymentCash.dart';
import 'package:mobelease/screens/Employee/PaymentCredit.dart';
import 'package:mobelease/screens/Employee/Reports.dart';
import 'package:mobelease/screens/Inventory/AddDevice.dart';
import 'package:mobelease/screens/Admin/Employee.dart';
import 'package:mobelease/screens/Remarks.dart';
import 'package:mobelease/widgets/Chatbox.dart';
import 'controllers/Assign_Provider.dart';
import 'package:mobelease/screens/login.dart';
import 'screens/Admin/addEmployee.dart';
import 'screens/init_screen.dart';

import 'screens/Admin/EmployeeSelect.dart';
import 'screens/Admin/Assign.dart';
import 'screens/notifications.dart';
import 'screens/Inventory/Inventory.dart';
import 'screens/Message.dart';
import 'controllers/ProtectedRoute.dart';
import 'screens/Admin/EmployeeAll.dart';
import 'package:provider/provider.dart';
import 'screens/Employee/Emp_Assign_1.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('authToken');
  print("token $token");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) => EmployeeProvider()..getEmployee()),
      ChangeNotifierProvider(create: (context) => SelectedDevicesProvider())
    ],
    child: MyApp(token: token ?? ""),
  ));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String token;
  MyApp({required this.token});

  String inRoute = "";

  @override
  Widget build(BuildContext context) {
    //if (token == "") {
    //inRoute = '/login';
    //} else {
    //inRoute = '/Employee';
    // }
    inRoute = '/login';
    return MaterialApp(
        initialRoute: inRoute,
        routes: {
          '/login': (context) => Login(
                loginMember: 'EMPLOYEE',
              ),
          '/home': (context) => InitScreen(),
          '/notifications': (context) => ProtectedPage(child: Notifications()),
          '/Employee': (context) => ProtectedPage(child: Employee()),
          '/addEmployee': (context) => ProtectedPage(child: addEmployee()),
          // '/Employeeuser':(context) => Employeeuser(),

          '/EmployeeSelect': (context) =>
              ProtectedPage(child: EmployeeSelect()),
          '/Assign': (context) => ProtectedPage(child: Assign(id: 1)),
          '/AssigningPage': (context) => ProtectedPage(child: AssigningPage()),
          '/Inventory': (context) => ProtectedPage(child: Inventory()),
          '/Remarks': (context) => ProtectedPage(child: Remarks()),
          '/Message': (context) => ProtectedPage(child: Message()),
          '/EmployeeAll': (context) => ProtectedPage(child: EmployeeAll()),
          '/AddDevice': (context) => ProtectedPage(child: AddDeviceDialog()),
          '/Emp_home': (context) => Emp_home(),
          'Emp_chatbox': (context) => ctbox(),
          '/Emp_Assign_1': (context) => Emp_Assign_1(),
          '/Emp_Assign_2': (context) => Emp_Assign_2(),
          '/Emp_Inventory': (context) => Emp_Inventory(),
          '/PaymentCash': (context) => PaymentCash(),
          '/PaymentCredit': (context) => PaymentCredit(),
          '/Emp_Reports_1': (context) => Emp_Reports_1(),
          '/Reports': (context) => Reports(
                dues: false,
                cash: true,
                paid: true,
              )
        },
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffFEF9F7),
          primarySwatch: Colors.blue,
        ),
        home: Login(
          loginMember: 'EMPLOYEE',
        ));
  }
}
