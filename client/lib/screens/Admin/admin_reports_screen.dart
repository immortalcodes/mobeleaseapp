import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobelease/controllers/auth_controller.dart';
import 'package:mobelease/globals.dart';
import 'package:mobelease/models/Employee_Model.dart';
import 'package:mobelease/screens/Admin/Employee.dart';
import 'package:mobelease/widgets/Appbar.dart';
import 'package:mobelease/widgets/BottomAppBar.dart';
import 'package:mobelease/widgets/EmployeeDataCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ReportsScreen extends StatefulWidget {
  String dropDown;
  int empId;
  int empIdSale;
  ReportsScreen(
      {super.key,
      required this.dropDown,
      required this.empId,
      required this.empIdSale});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final AuthController authController = AuthController();
  List<String> saleIds = [];
  String? empId;
  String? type;
  String? status;
  List<EmployeeModel> employeesList = [];

  OutlineInputBorder kEnabledTextFieldBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xffE96E2B)),
      borderRadius: BorderRadius.circular(15));

  OutlineInputBorder kFocusedTextFieldBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffE96E2B), width: 2),
      borderRadius: BorderRadius.circular(15));

  int? prevEmployeeIndex;

  Future<dynamic> getStatistics(
      int empId, String startTime, String endTime) async {
    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/sale/viewstats');
    var headers = {
      'accept': 'application/json',
      'Cookie': '${token}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', url);
    //"2021-09-15"
    //"2023-12-15"
    request.body = json
        .encode({"empid": empId, "starttime": startTime, "endtime": endTime});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = jsonDecode(await response.stream.bytesToString());
      print(res);
      return res;
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<List<String>> getEmployeeNames() async {
    final token = await authController.getToken();
    print(token);
    var url = Uri.parse('$baseUrl/emp/allemployee');
    final client = http.Client();
    try {
      final response = await client.post(
        url,
        headers: {'Cookie': token!, 'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            jsonDecode(response.body)!['data'];
        final List<String> sortedKeys1 = responseData.keys.toList();
        List<int> sortedKeys =
            sortedKeys1.map((str) => int.parse(str!)).toList()..sort();
        // print(sortedKeys);
        final List<EmployeeModel> employees = sortedKeys
            .map((key) => EmployeeModel.fromJson(responseData[key.toString()]))
            .toList();
        print('response data: $responseData');
        print("keys $sortedKeys");
        print(employees);
        employeesList = employees;
        List<String> names = [];
        for (EmployeeModel employee in employeesList) {
          String name = employee.firstName! + " " + employee.lastName!;
          names.add(name);
        }
        names.add("all");
        // setState(() {});
        return names;
        // if(mounted) {
        //   setState(() {
        //
        // });
        // }
      } else {
        throw Exception('Failed to load employees');
      }

      // return employees;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> viewAllSale(String starttime,
      String endtime, String status, String empId, String saletype) async {
    var url = Uri.parse('$baseUrl/sale/viewallsale');
    final token = await authController.getToken();
    print("token $token");
    // DateTime today = DateTime.now();
    // DateTime tomorrow = today.add(Duration(days: 2));
    // final String endtime = DateFormat('yyyy-MM-dd').format(tomorrow);
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "starttime": starttime,
          "endtime": endtime,
          "status": status,
          "empid": empId,
          "saletype": saletype
        }),
        headers: {'Cookie': token!, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> viewSalesData =
            jsonDecode(response.body)!['data'];
        // print("veiw sal $viewSalesData");
        List<Map<String, dynamic>> salesList =
            List<Map<String, dynamic>>.from(viewSalesData.values);

        saleIds = List<String>.from(viewSalesData.keys);

        return salesList;
      } else {
        print("failed to load viewSalesData");
      }
    } catch (e) {
      return Future.error(e.toString());
    }
    return [];
  }

  String formatTimestamp(String timestamp) {
    final inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS");
    final outputFormat = DateFormat("dd/MM/yyyy");

    final parsedDate = inputFormat.parse(timestamp, true);
    return outputFormat.format(parsedDate);
  }

  String startDate(String value) {
    print("Heyyyyyyyyyyyyyy");
    print(value);
    return value;
  }

  String endDate(String value) {
    print(value);
    return value;
  }

  TextEditingController startDateControllerSale = TextEditingController(
      text:
          '${DateTime.now().year}-${DateTime.now().month - 1}-${DateTime.now().day}');

  TextEditingController endDateControllerSale = TextEditingController(
      text:
          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}');

  TextEditingController startDateController = TextEditingController(
      text:
          '${DateTime.now().year}-${DateTime.now().month - 1}-${DateTime.now().day}');
  TextEditingController endDateController = TextEditingController(
      text:
          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}');

  String? prevStartDate;
  String? prevEndDate;
  String? prevStatus;
  String? prevType;
  int? indexStatus;
  int? indexType;

  String tester(String test) {
    print("Yoooooooooooooooooooooooooooo");
    print(test);
    return test;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    prevStartDate = startDateControllerSale.text;
    prevEndDate = endDateControllerSale.text;
    prevStatus = "*all*";
    status = "*all*";
    type = "*all*";
    indexStatus = 2;
    indexType = 2;
    prevType = "*all*";
  }

  // List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 11.0,
              ),
              child: Appbar(),
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: getStatistics(
                    widget.empId,
                    startDate(startDateController.text),
                    endDate(endDateController.text)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Placeholder for loading state
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    var stats = snapshot.data['data'];
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reports",
                                style: TextStyle(
                                    fontSize: 20, color: Color(0xffE96E2B)),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 80,
                                    child: TextFormField(
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1800),
                                          lastDate: DateTime.now(),
                                        );
                                        if (pickedDate != null) {
                                          startDateController.text =
                                              DateFormat("yyyy-MM-dd")
                                                  .format(pickedDate)
                                                  .toString();
                                          setState(() {});
                                        }
                                      },
                                      style: TextStyle(fontSize: 10),
                                      validator: (value) => value!.isNotEmpty
                                          ? null
                                          : "Enter Valid Date",
                                      readOnly: true,
                                      controller: startDateController,
                                      keyboardType: TextInputType.text,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                        border: kEnabledTextFieldBorder,
                                        enabledBorder: kEnabledTextFieldBorder,
                                        focusedBorder: kFocusedTextFieldBorder,
                                        contentPadding: EdgeInsets.all(10),
                                        labelText: "Start Date",
                                        labelStyle: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    height: 60,
                                    width: 80,
                                    child: TextFormField(
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1800),
                                          lastDate: DateTime.now(),
                                        );
                                        if (pickedDate != null) {
                                          endDateController.text =
                                              DateFormat("yyyy-MM-dd")
                                                  .format(pickedDate)
                                                  .toString();
                                          setState(() {});
                                        }
                                      },
                                      style: TextStyle(fontSize: 10),
                                      validator: (value) => value!.isNotEmpty
                                          ? null
                                          : "Enter Valid Date",
                                      readOnly: true,
                                      controller: endDateController,
                                      keyboardType: TextInputType.text,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                        border: kEnabledTextFieldBorder,
                                        enabledBorder: kEnabledTextFieldBorder,
                                        focusedBorder: kFocusedTextFieldBorder,
                                        contentPadding: EdgeInsets.all(10),
                                        labelText: "Start Date",
                                        labelStyle: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  FutureBuilder(
                                    future: getEmployeeNames(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator(); // Placeholder for loading state
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        return DropdownMenu<String>(
                                          initialSelection: widget.dropDown,
                                          width: 130,
                                          onSelected: (String? value) {
                                            // This is called when the user selects an item.
                                            int index;
                                            value == "all"
                                                ? index = 0
                                                : index = snapshot.data!
                                                        .indexOf(value!) +
                                                    1;
                                            print(index);
                                            setState(() {
                                              widget.dropDown = value!;
                                              widget.empId = index;
                                            });
                                          },
                                          dropdownMenuEntries: snapshot.data!
                                              .map<DropdownMenuEntry<String>>(
                                                  (String value) {
                                            return DropdownMenuEntry<String>(
                                                value: value, label: value);
                                          }).toList(),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 219, 201, 243),
                                    ),
                                    height: 60,
                                    width: 125,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 11,
                                                backgroundColor: Color.fromARGB(
                                                    255, 113, 23, 240),
                                                child: Icon(
                                                  Icons.poll_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Total Sale Cash",
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Text(
                                                  '\$ ${stats['cash_totalsale']}'),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 186, 241, 227),
                                    ),
                                    height: 60,
                                    width: 125,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 11,
                                                backgroundColor: Color.fromARGB(
                                                    255, 10, 203, 190),
                                                child: Icon(
                                                  Icons.poll_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Profit Credit",
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Text(
                                                  '\$ ${stats['profit_credit'] == null ? 0 : stats['profit_credit']}'),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 243, 201, 232),
                                    ),
                                    height: 60,
                                    width: 125,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 11,
                                                backgroundColor: Color.fromARGB(
                                                    255, 240, 23, 204),
                                                child: Icon(
                                                  Icons.poll_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Profit Cash",
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Text(
                                                  '\$ ${stats['profit_cash']}'),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 241, 232, 186),
                                    ),
                                    height: 60,
                                    width: 125,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 11,
                                                backgroundColor: Color.fromARGB(
                                                    255, 203, 171, 10),
                                                child: Icon(
                                                  Icons.poll_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Total Profit",
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Text(
                                                  '\$ ${stats['total_profit'] == null ? 0 : stats['total_profit']}'),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 247, 218, 194),
                                    ),
                                    height: 60,
                                    width: 125,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 11,
                                                backgroundColor: Color.fromARGB(
                                                    255, 240, 123, 13),
                                                child: Icon(
                                                  Icons.poll_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Total Sale Credit",
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Text(
                                                  '\$ ${stats['credit_totalsale']}'),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            Color.fromARGB(255, 217, 241, 218)),
                                    height: 60,
                                    width: 125,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 11,
                                                backgroundColor: Color.fromARGB(
                                                    255, 10, 170, 93),
                                                child: Icon(
                                                  Icons.poll_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Credit COGS",
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Text(
                                                  '\$ ${stats['credit_cogs']}'),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 201, 229, 243),
                                    ),
                                    height: 60,
                                    width: 120,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 11,
                                                backgroundColor: Color.fromARGB(
                                                    255, 23, 142, 240),
                                                child: Icon(
                                                  Icons.poll_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Total credit left",
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Text('\$ ${stats['creditleft']}'),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 233, 241, 186),
                                    ),
                                    height: 60,
                                    width: 120,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 11,
                                                backgroundColor: Color.fromARGB(
                                                    255, 174, 203, 10),
                                                child: Icon(
                                                  Icons.poll_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Stolen loss",
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Text(
                                                  '\$ ${stats['stolen_loss'] == null ? 0 : stats['stolen_loss']}'),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 186, 205, 241),
                                ),
                                height: 60,
                                width: 120,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 11,
                                            backgroundColor: Color.fromARGB(
                                                255, 10, 87, 203),
                                            child: Icon(
                                              Icons.poll_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Cash COGS",
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Text(
                                              '\$ ${stats['cash_cogs'] == null ? 0 : stats['cash_cogs']}'),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Sales",
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xffE96E2B)),
                              ),
                              IconButton(
                                  splashRadius: 20,
                                  onPressed: () {
                                    prevEmployeeIndex = widget.empIdSale;
                                    prevStartDate =
                                        startDateControllerSale.text;
                                    prevEndDate = endDateControllerSale.text;
                                    prevStatus = status;
                                    prevType = type;
                                    showAdaptiveDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog.adaptive(
                                        title: const Text(
                                            'Apply Filters on Sales'),
                                        content: Column(
                                          children: [
                                            Text("Select Employee"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            FutureBuilder(
                                              future: getEmployeeNames(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return CircularProgressIndicator(); // Placeholder for loading state
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else {
                                                  return DropdownMenu<String>(
                                                    initialSelection:
                                                        widget.dropDown,
                                                    width: 130,
                                                    onSelected:
                                                        (String? value) {
                                                      // This is called when the user selects an item.
                                                      int index;
                                                      value == "all"
                                                          ? index = 0
                                                          : index = snapshot
                                                                  .data!
                                                                  .indexOf(
                                                                      value!) +
                                                              1;
                                                      print(index);
                                                      setState(() {
                                                        widget.dropDown =
                                                            value!;
                                                        widget.empIdSale =
                                                            index;
                                                      });
                                                    },
                                                    dropdownMenuEntries:
                                                        snapshot.data!.map<
                                                            DropdownMenuEntry<
                                                                String>>((String
                                                            value) {
                                                      return DropdownMenuEntry<
                                                              String>(
                                                          value: value,
                                                          label: value);
                                                    }).toList(),
                                                  );
                                                }
                                              },
                                            ),
                                            SizedBox(
                                              height: 40,
                                            ),
                                            Text("Select Payment Type"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            // Here, default theme colors are used for activeBgColor, activeFgColor, inactiveBgColor and inactiveFgColor
                                            ToggleSwitch(
                                              initialLabelIndex: indexType,
                                              totalSwitches: 3,
                                              labels: ['Credit', 'Cash', 'All'],
                                              onToggle: (index) {
                                                print(index);
                                                indexType = index;
                                                index == 0
                                                    ? type = "credit"
                                                    : index == 1
                                                        ? type = "cash"
                                                        : type = "*all*";
                                                print(status);
                                                print('switched to: $index');
                                              },
                                            ),
                                            SizedBox(
                                              height: 40,
                                            ),
                                            Text("Select Payment Status"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            ToggleSwitch(
                                              initialLabelIndex: indexStatus,
                                              totalSwitches: 3,
                                              labels: ['Paid', 'Due', 'All'],
                                              onToggle: (index) {
                                                indexStatus = index;
                                                index == 0
                                                    ? status = "paid"
                                                    : index == 1
                                                        ? status = "due"
                                                        : status = "*all*";
                                                print(type);
                                                print('switched to: $index');
                                              },
                                            ),
                                            SizedBox(
                                              height: 60,
                                            ),
                                            SizedBox(
                                              width: 160,
                                              child: TextFormField(
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1800),
                                                    lastDate: DateTime.now(),
                                                  );
                                                  if (pickedDate != null) {
                                                    startDateControllerSale
                                                            .text =
                                                        DateFormat("yyyy-MM-dd")
                                                            .format(pickedDate)
                                                            .toString();
                                                    setState(() {});
                                                  }
                                                },
                                                style: TextStyle(fontSize: 16),
                                                validator: (value) =>
                                                    value!.isNotEmpty
                                                        ? null
                                                        : "Enter Valid Date",
                                                readOnly: true,
                                                controller:
                                                    startDateControllerSale,
                                                keyboardType:
                                                    TextInputType.text,
                                                autocorrect: false,
                                                decoration: InputDecoration(
                                                  border:
                                                      kEnabledTextFieldBorder,
                                                  enabledBorder:
                                                      kEnabledTextFieldBorder,
                                                  focusedBorder:
                                                      kFocusedTextFieldBorder,
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  labelText: "Start Date",
                                                  labelStyle:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 60,
                                            ),
                                            SizedBox(
                                              width: 160,
                                              child: TextFormField(
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1800),
                                                    lastDate: DateTime.now(),
                                                  );
                                                  if (pickedDate != null) {
                                                    endDateControllerSale.text =
                                                        DateFormat("yyyy-MM-dd")
                                                            .format(pickedDate)
                                                            .toString();
                                                    setState(() {});
                                                  }
                                                },
                                                style: TextStyle(fontSize: 16),
                                                validator: (value) =>
                                                    value!.isNotEmpty
                                                        ? null
                                                        : "Enter Valid Date",
                                                readOnly: true,
                                                controller:
                                                    endDateControllerSale,
                                                keyboardType:
                                                    TextInputType.text,
                                                autocorrect: false,
                                                decoration: InputDecoration(
                                                  border:
                                                      kEnabledTextFieldBorder,
                                                  enabledBorder:
                                                      kEnabledTextFieldBorder,
                                                  focusedBorder:
                                                      kFocusedTextFieldBorder,
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  labelText: "End Date",
                                                  labelStyle:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              print(prevStartDate);
                                              startDateControllerSale.text =
                                                  prevStartDate!;
                                              print(prevEndDate);
                                              endDateControllerSale.text =
                                                  prevEndDate!;
                                              print(prevEmployeeIndex);
                                              widget.empIdSale =
                                                  prevEmployeeIndex!;
                                              status = prevStatus;
                                              type = prevType;
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.filter_alt,
                                    color: Color(0xffE96E2B),
                                  ))
                            ],
                          ),
                        ),
                        FutureBuilder(
                            future: viewAllSale(
                                startDateControllerSale.text,
                                endDateControllerSale.text,
                                tester(status!),
                                widget.empIdSale.toString(),
                                tester(type!)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Placeholder for loading state
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                List<Map<String, dynamic>> salesData =
                                    snapshot.data!;
                                print(salesData);
                                return Container(
                                  // Wrap the ListView with a Container to constrain its height
                                  height: MediaQuery.of(context).size.height *
                                      0.4, // Adjust the height as needed
                                  child: ListView.builder(
                                    itemCount: salesData.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: EmployeeDataCard(
                                          saleId: int.parse(saleIds[index]),
                                          cost: salesData[index]['totalsale'],
                                          date: formatTimestamp(
                                              salesData[index]['timestamp']),
                                          name: salesData[index]
                                                  ['customername'] ??
                                              "",
                                          cash: salesData[index]['saletype'] ==
                                              "cash",
                                          paid: salesData[index]['status'] ==
                                              "paid",
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            }),
                      ],
                    );
                  }
                })
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBar(index: 2),
    );
  }
}
