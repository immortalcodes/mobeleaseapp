import 'package:flutter/material.dart';
import 'package:mobelease/controllers/employee_controller.dart';
import 'package:mobelease/screens/Admin/AssigningPage.dart';
import 'package:mobelease/screens/Employee/Emp_home.dart';
import 'package:mobelease/screens/Inventory/AddDevice.dart';
import 'package:mobelease/screens/Admin/Employee.dart';
import 'package:mobelease/screens/Remarks.dart';
import 'controllers/Assign_Provider.dart';
import 'package:mobelease/screens/login.dart';
import 'screens/Admin/addEmployee.dart';
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
        create: (context)=>EmployeeProvider()..getEmployee()),
      ChangeNotifierProvider(create: (context)=> SelectedDevicesProvider())],
    child: MyApp(),));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {

  String inRoute= '/Emp_home';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: inRoute,
        routes: {
          '/login': (context) => Login(loginMember: 'EMPLOYEE',),
          '/home': (context) => InitScreen(),
          '/notifications': (context) => ProtectedPage(child: Notifications()),
          '/Employee': (context) => ProtectedPage(child: Employee()),
          '/addEmployee': (context) => ProtectedPage(child: addEmployee()),
          // '/Employeeuser':(context) => Employeeuser(),
          '/EmployeePersonal': (context) => ProtectedPage(child: EmployeePersonal(id:1)),
          '/EmployeeSelect' : (context) => ProtectedPage(child: EmployeeSelect()),
          '/Assign' : (context) => ProtectedPage(child: Assign(id:1)),
          '/AssigningPage' :(context) => ProtectedPage(child: DeviceSelectionScreen()),
          '/Inventory' : (context) => ProtectedPage(child: Inventory()),
          '/Remarks' : (context) => ProtectedPage(child: Remarks()),
          '/Message' : (context) => ProtectedPage(child: Message()),
          '/EmployeeAll': (context) => ProtectedPage(child: EmployeeAll()),
          '/AddDevice' : (context) => ProtectedPage(child: AddDeviceDialog()),
          '/Emp_home' : (context) => Emp_home()
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
