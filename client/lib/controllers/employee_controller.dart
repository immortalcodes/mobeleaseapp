import 'package:flutter/material.dart';
import '../models/Employee_Model.dart';
import '../repository/employee_repository.dart';

class EmployeeProvider extends ChangeNotifier {
  List<EmployeeModel> employeeData = [];
  bool isLoading = true;

  Future<List<EmployeeModel>> getEmployee() async {
    EmployeeRepository employeeRepository = EmployeeRepository();
    employeeData = await employeeRepository.getEmployees();
    isLoading = false;
    notifyListeners();
    return employeeData;
  }

  // Future<void> addToCart(EmployeeModel product) async {
  //   await EmployeeRepository() . addProductToCart(product.toCartJson());
  //   getCart();
  // }
}
