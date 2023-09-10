import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class Categories {
  late String title;
  late String svgpath;
  Function() onpress;

  Categories({required this.title,required this.svgpath, required this.onpress});

  ElevatedButton buildCategories() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          elevation: 0.0,
          minimumSize: Size(66, 26),
          textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      onPressed: onpress,
      child: Row(
        children: [
          SvgPicture.asset(svgpath, color: Color(0xffE96E2B),),
          Text(
            title,
            style: TextStyle(color: Color(0xffE96E2B)),
          ),
        ],
      ),
    );
  }
}

// class Category extends StatefulWidget {
//   late String title;
//   late String svgpath;
//   late Color back= Colors.grey;
//   late Color fore= Color(0xffE96E2B);
//   Category({required this.title,required this.svgpath});
//
//   @override
//   State<Category> createState() => _CategoryState();
// }
//
//
// class _CategoryState extends State<Category> {
//
//   void _onItemTapped(){
//     setState((){
//       back,fore=fore,back;
//     });
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//     onTap: (){
//
//     },
//       child: Container(
//         decoration: ShapeDecoration(
//           shape: StadiumBorder(),
//         ),
//         child: Row(
//           children: [
//             SvgPicture.asset(widget.svgpath, color: Color(0xffE96E2B),),
//             Text(widget.title, style: TextStyle(color: Color(0xffE96E2B)),
//       ),
//           ],
//         ),
//     );
//   }
// }
//
