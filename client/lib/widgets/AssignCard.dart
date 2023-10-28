import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssignCard extends StatefulWidget {
  late String model;
  late String quantity;
  late String company;
  int? deviceId;
  Set<Map<String, dynamic>>? isselecttedItemsList;

  AssignCard(
      {required this.model,
      required this.quantity,
      required this.company,
      this.deviceId,
      this.isselecttedItemsList});
  @override
  _AssignCardState createState() => _AssignCardState();
}

class _AssignCardState extends State<AssignCard> {
  bool isSelected = false;

  int localQuantity = 0;

  @override
  void initState() {
    super.initState();
    localQuantity = int.parse(widget.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          isSelected = !isSelected;
          if (isSelected) {
            widget.isselecttedItemsList!
                .add({"deviceId": widget.deviceId, "quantity": localQuantity});
          } else {
            widget.isselecttedItemsList!.removeWhere((item) =>
                item["deviceId"] == widget.deviceId &&
                item["quantity"] == localQuantity);
          }
        });

        print(widget.isselecttedItemsList);
      },
      child: Container(
        height: 47.0,
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 247, 235, 239) : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: isSelected
              ? Border.all(color: Color.fromRGBO(233, 110, 43, 0.50), width: 1)
              : Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                SvgPicture.asset('assets/svgs/MobileTag.svg'),
                SizedBox(width: 20),
                Text(widget.model,
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
            Row(
              children: [
                Text(widget.company,
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Quantity",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 2.50,
                ),
                SizedBox(
                  width: 5.0,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      localQuantity -= 1;
                    });
                  },
                  child: Icon(
                    Icons.remove_circle,
                    color: Color(0xffE96E2B),
                  ),
                ),
                Text(
                  localQuantity.toString(),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      localQuantity += 1;
                    });
                  },
                  child: Icon(
                    Icons.add_circle,
                    color: Color(0xffE96E2B),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
