import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentCard extends StatefulWidget {
  String item = '';
  int quantity = 0;
  Function(double, double)? onUpdateprice;

  PaymentCard({
    required this.item,
    required this.quantity,
    this.onUpdateprice,
  });

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  double updatedPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: Colors.black12, width: 0.3),
              bottom: BorderSide(color: Colors.black12, width: 0.3))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.16,
                child: Text(widget.item,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
                    textAlign: TextAlign.center)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
            ),
            Text(
              '${widget.quantity}',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            Row(
              children: [
                Text(
                  '\$ $updatedPrice',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                ),
                // SvgPicture.asset('assets/svgs/pen.svg', width: 10,color: Color(0xffE96E2B)),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController _priceController =
                              TextEditingController(
                                  text: updatedPrice.toString());
                          return AlertDialog(
                            title: Text('Edit Price'),
                            content: TextFormField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Enter new price",
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Save'),
                                onPressed: () {
                                  double newPrice =
                                      double.tryParse(_priceController.text) ??
                                          0;
                                  if (newPrice != 0) {
                                    setState(() {
                                      updatedPrice = newPrice;
                                    });
                                    widget.onUpdateprice!(
                                        widget.quantity * updatedPrice,
                                        updatedPrice);
                                    Navigator.of(context).pop();
                                    // Add code to save the new price
                                  }
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: Icon(Icons.edit, color: Colors.orange, size: 12),
                )
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            Text(
              '\$ ${widget.quantity * updatedPrice}',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
