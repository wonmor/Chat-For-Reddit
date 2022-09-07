import 'dart:math';
import 'package:flutter/material.dart';

import 'custom_image.dart';

class StoryBox extends StatelessWidget {
  StoryBox({ Key? key, required this.data }) : super(key: key);
  final data;

  @override
  Widget build(BuildContext context) {
    return 
      Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Color(Random().nextInt(0xffffffff)).withAlpha(0xff),),
                shape: BoxShape.circle
              ),  
              child: CustomImage(
                data["image"].toString(), isSVG: false,
                width: 40, height: 40,
              ),
            ),
            SizedBox(height: 5,),
            Text(data["fname"].toString(), maxLines: 1, overflow: TextOverflow.fade,)
          ],
        ),
      );
  }
}