import 'package:flutter/material.dart';
import 'package:mobelease/controllers/employee_controller.dart';
import 'package:mobelease/screens/Inventory/AddDevice.dart';
import 'package:mobelease/screens/Admin/Employee.dart';
import 'package:mobelease/screens/Remarks.dart';
// import 'package:mobelease/screens/add_employee.dart';
import 'package:mobelease/screens/login.dart';
import 'screens/addEmployee.dart';
import 'screens/init_screen.dart';
import 'screens/Admin/EmployeePersonal.dart';
import 'screens/Admin/EmployeeSelect.dart';
import 'screens/Admin/Assign.dart';
import 'screens/notifications.dart';
import 'screens/Inventory/Inventory.dart';
import 'screens/Message.dart';
import 'controllers/ProtectedRoute.dart';
import 'screens/Admin/EmployeeAll.dart';
import 'package:provider/provider.dart';
import 'screens/Inventory/AddDevice.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(
        create: (context)=>EmployeeProvider()..getEmployee())],
    child: MyApp(),));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {

  String inRoute= '/home';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: inRoute,
        routes: {
          '/login': (context) => Login(loginMember: 'EMPLOYEE',),
          '/home': (context) => InitScreen(),
          '/notifications': (context) => Notifications(),
          '/Employee': (context) => ProtectedPage(child: Employee()),
          '/addEmployee': (context) => addEmployee(),
          // '/Employeeuser':(context) => Employeeuser(),
          '/EmployeePersonal': (context) => EmployeePersonal(id:1),
          '/EmployeeSelect' : (context) => EmployeeSelect(),
          '/Assign' : (context) => Assign(id:1),
          // '/add_employee' : (context) => AddEmployee(),
          '/Inventory' : (context) => Inventory(),
          '/Remarks' : (context) => Remarks(),
          '/Message' : (context) => Message(),
          '/EmployeeAll': (context) => EmployeeAll(),
          '/AddDevice' : (context) => AddDeviceDialog()
        },
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: Color(0xffFEF9F7),
          primarySwatch: Colors.blue,
        ),
        home: Employee());
  }
}
