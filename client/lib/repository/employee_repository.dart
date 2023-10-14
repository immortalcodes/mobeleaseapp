import 'dart:convert';
import 'dart:core';
import 'package:mobelease/screens/Admin/Employee.dart';
import '../controllers/auth_controller.dart';
import '../globals.dart' as globals;
import '../models/Employee_Model.dart';
import 'package:http/http.dart' as http;

class EmployeeRepository {
  AuthController authController = AuthController();
  String baseUrl = globals.baseUrl;

  Future<List<EmployeeModel>> getEmployees() async {
    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/emp/allemployee');
    final client = http.Client();
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/emp/allemployee'),
        headers: {'Cookie': token!, 'Content-Type': 'application/json'},
      );
      final Map<String, dynamic> responseData =
          jsonDecode(response.body)['data'];
      final List<EmployeeModel> employees = responseData.values
          .map((employeeData) => EmployeeModel.fromJson(employeeData))
          .toList();
      print(employees);
      return employees;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Future<void> addProductToCart(String product) async{
  //   await http.post(Uri.http('10.0.2.2:8080', '/cart'),
  //       body: product);
  // }
}
