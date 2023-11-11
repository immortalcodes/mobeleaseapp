import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Categories {
  late String title;
  late String svgpath;
  Function() onpress;
  late String selectedCategory;

  Categories({
    required this.title,
    required this.svgpath,
    required this.onpress,
    required this.selectedCategory,
  });

  ElevatedButton buildCategories() {
    Color getBackgroundColor() {
      if (title == selectedCategory) {
        return Color(0xffE96E2B); // Highlight color for selected category
      }
      return Colors.grey[300]!; // Default background color
    }

    // void _scrollToCategory() {
    //   // Find the index of the selected category in the map keys
    //   int index = categorizedDevices.keys.toList().indexOf(title);
    //   int length = categorizedDevices.length.toInt();
    //   if (index != -1) {
    //     // Scroll to the category's position
    //     scrollController.animateTo(
    //       (index * length) as double, // Replace with your item width
    //       duration: Duration(milliseconds: 500),
    //       curve: Curves.easeInOut,
    //     );
    //   }
    // }
    Color getTitleColor() {
      if (title == selectedCategory) {
        return Colors.white; // Highlight color for selected category
      }
      return Color(0xffE96E2B); // Default background color
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: getBackgroundColor(),
          elevation: 0.0,
          minimumSize: Size(66, 26),
          textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      onPressed: onpress,
      child: Row(
        children: [
          svgpath.isEmpty
              ? Text("")
              : SvgPicture.asset(
                  svgpath,
                  color: Color(0xffE96E2B),
                ),
          SizedBox(width: 5),
          Text(
            title,
            style: TextStyle(color: getTitleColor()),
          ),
        ],
      ),
    );
  }
}
