import 'package:flutter/material.dart';

class RoundTextBox extends StatelessWidget {
  const RoundTextBox({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
      Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(50)
        ),
        child: TextField(
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 17)),
        ),
      );
  }
}