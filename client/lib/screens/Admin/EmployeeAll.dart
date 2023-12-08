import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobelease/screens/Admin/EmployeePersonal.dart';
import 'package:mobelease/ui_sizes.dart';
import '../../controllers/auth_controller.dart';
import '../../models/Employee_Model.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/BottomAppBar.dart';
import '../../widgets/Employee_Icon.dart';

class EmployeeAll extends StatefulWidget {
  List<EmployeeModel>? employeeList;
  EmployeeAll({super.key, this.employeeList});

  @override
  State<EmployeeAll> createState() => _EmployeeAllState();
}

class _EmployeeAllState extends State<EmployeeAll> {
  final AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: UiSizes(context: context).height_11,
                  left: UiSizes(context: context).width_11,
                  right: UiSizes(context: context).width_11),
              child: Appbar(),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: UiSizes(context: context).height_23,
                  bottom: UiSizes(context: context).height_23,
                  left: UiSizes(context: context).width_18,
                  right: UiSizes(context: context).width_18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText("List of all Employees",
                      style: TextStyle(
                          color: Color(0xffE96E2B),
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0)),
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
                   EdgeInsets.symmetric(horizontal: UiSizes(context: context).width_18, vertical: UiSizes(context: context).height_7),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xffE96E2B),
                  ),
                  hintText: "Search Employees",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9.0),
                    borderSide: BorderSide(color: Color(0xffE96E2B)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.employeeList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final employee = widget.employeeList![index];

                    return Padding(
                      padding:  EdgeInsets.symmetric(
                          horizontal: UiSizes(context: context).width_18, vertical: UiSizes(context: context).height_4),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EmployeePersonal(empid: index + 1),
                            ),
                          );
                        },
                        child: ListTile(
                          leading:
                              Employee_icon(imagePath: employee.empPhoto ?? ""),
                          title: AutoSizeText(
                            employee.firstName ?? 'No First Name Available',
                          ),
                          trailing: Icon(
                            Icons.arrow_right,
                            color: Color(0xffE96E2B),
                          ),
                          tileColor: Colors.white,
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBar(index: 0),
    );
  }
}
