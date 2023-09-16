import 'package:flutter/material.dart';

class Appbar extends StatefulWidget {
  const Appbar({super.key});

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  @override
  Row build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image(
          image: AssetImage("assets/images/logo.png"),
          width: 99.0,
          height: 55.0,
        ),
        GestureDetector(
          child: const Icon(Icons.notifications, color: Color(0xffE96E2B)),
          onTap: () {
            Navigator.of(context).pushNamed('/notifications');
          },
        ),
      ],
    );
  }
}
