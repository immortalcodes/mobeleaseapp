import 'dart:typed_data';

class EmployeeModel {
  final int? id;
  final String? empPhoto;
  final String? firstName;
  final String? lastName;
  final String? phoneNo;
  final String? email;

  EmployeeModel({
    this.id,
    this.empPhoto,
    this.firstName,
    this.lastName,
    this.phoneNo,
    this.email,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id:json['empid'],
      empPhoto: json['empphoto'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      phoneNo: json['phoneno'],
      email: json['email'],
    );
  }
}

