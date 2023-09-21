import 'package:flutter/material.dart';
import 'package:mobelease/controllers/employee_controller.dart';
import 'package:mobelease/screens/Admin/assigning_page.dart';
import 'package:mobelease/screens/employee/emp_home.dart';
import 'package:mobelease/screens/inventory/add_device.dart';
import 'package:mobelease/screens/Admin/employee.dart';
import 'package:mobelease/screens/remarks.dart';
import 'controllers/assign_provider.dart';
import 'package:mobelease/screens/login.dart';
import 'screens/Admin/add_employee.dart';
import 'screens/init_screen.dart';
import 'screens/Admin/employee_personal.dart';
import 'screens/Admin/employee_select.dart';
import 'screens/Admin/assign.dart';
import 'screens/notifications.dart';
import 'screens/inventory/inventory.dart';
import 'screens/message.dart';
import 'controllers/protected_route.dart';
import 'screens/Admin/employee_all.dart';
import 'package:provider/provider.dart';
import 'screens/inventory/add_device.dart';



void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(
        create: (context)=>EmployeeProvider()..getEmployee()),
      ChangeNotifierProvider(create: (context)=> SelectedDevicesProvider())],
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
          '/notifications': (context) => ProtectedPage(child: Notifications()),
          '/Employee': (context) => ProtectedPage(child: Employee()),
          '/addEmployee': (context) => ProtectedPage(child: addEmployee()),
          // '/Employeeuser':(context) => Employeeuser(),
          '/EmployeePersonal': (context) => ProtectedPage(child: EmployeePersonal(id:1)),
          '/EmployeeSelect' : (context) => ProtectedPage(child: EmployeeSelect()),
          '/Assign' : (context) => ProtectedPage(child: Assign(id:1)),
          // '/AssigningPage' :(context) => ProtectedPage(child: DeviceSelectionScreen()),
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
        home: InitScreen());
  }
}
