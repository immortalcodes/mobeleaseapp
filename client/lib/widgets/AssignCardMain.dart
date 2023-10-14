import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobelease/controllers/auth_controller.dart';

class AssignCardMain extends StatefulWidget {
  late String model;
  late int quantity;
  late int deviceId;
  late String cost;
  late int empId;
  late int totalPrice;
  late String company;

  final Function(int, int) updateDeviceQuantity;

  AssignCardMain({
    required this.model,
    required this.quantity,
    required this.deviceId,
    required this.cost,
    required this.empId,
    required this.totalPrice,
    required this.company,
    required this.updateDeviceQuantity,
  });

  @override
  State<AssignCardMain> createState() => _AssignCardMainState();
}

class _AssignCardMainState extends State<AssignCardMain> {
  final AuthController authController = AuthController();
  int localQuantity = 0;

  @override
  void initState() {
    super.initState();

    localQuantity = widget.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 47.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: Offset(0, 8),
            ),
          ],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                SvgPicture.asset('assets/svgs/MobileTag.svg'),
                SizedBox(
                  width: 15,
                ),
                Text(widget.company,
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                SizedBox(
                  width: 15,
                ),
                Text(widget.model,
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 5),
                Text("\$ ${widget.cost}",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey)),
                SizedBox(width: 15),
                GestureDetector(
                  child: CircleAvatar(
                    radius: 10.0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.remove_circle,
                      color: Color(0xffE96E2B),
                    ),
                  ),
                  onTap: () async {
                    if (localQuantity >= 1) {
                      setState(() {
                        localQuantity = localQuantity - 1;
                        widget.totalPrice -= int.parse(widget.cost);
                      });
                      widget.updateDeviceQuantity(
                          widget.deviceId, localQuantity);
                    }
                  },
                ),
                SizedBox(width: 5),
                Text(
                  localQuantity.toString(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  child: CircleAvatar(
                    radius: 10.0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.add_circle,
                      color: Color(0xffE96E2B),
                    ),
                  ),
                  onTap: () async {
                    print("%%% ${widget.deviceId}");

                    setState(() {
                      localQuantity = localQuantity + 1;

                      widget.totalPrice += int.parse(widget.cost);
                    });
                    print("ddd $localQuantity");
                    widget.updateDeviceQuantity(widget.deviceId, localQuantity);
                  },
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
