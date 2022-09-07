import 'package:chat_firebase/theme/color.dart';
import 'package:flutter/material.dart';
import 'chat_item.dart';
import 'notify_box.dart';

class GroupBox extends StatelessWidget {
  GroupBox({ Key? key, required this.gruopData, this.bgColor = primary, this.onTap}) : super(key: key);
  
  final gruopData;
  final Color bgColor;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return 
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
          margin: EdgeInsets.fromLTRB(5, 5, 5, 15),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: bgColor.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 4,
                offset: Offset(3, 5), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(gruopData["title"], maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w600)
                    )
                  ),
                  NotifyBox(number: gruopData["notify"],)
                ],
              ),
              Container(child: ChatItem(gruopData, profileSize: 35, isNotified: false,))
            ],
          ),
        ),
      );
  }
}