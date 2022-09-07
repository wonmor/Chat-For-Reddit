
import 'package:chat_firebase/widgets/custom_image.dart';
import 'package:chat_firebase/widgets/notify_box.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  const ChatItem(this.chatData, { Key? key, this.onTap, this.isNotified = true, this.profileSize = 50}) : super(key: key);
  final chatData;
  final bool isNotified;
  final GestureTapCallback? onTap;
  final double profileSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
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
            SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImage(
                  chatData['image'], 
                  isSVG: false,
                  width: profileSize, height: profileSize,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: 
                  Container(
                    child:
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Text(chatData['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))
                                )
                              ),
                              SizedBox(width: 5),
                              Container(
                                child: Icon(Icons.remove_red_eye_outlined, size: 10, color: Colors.grey,)
                              ),
                              SizedBox(width: 3),
                              Container(
                                child: Text(chatData['date'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: Colors.grey))
                              )
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text(chatData['last_text'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13))),
                              if(isNotified)
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: NotifyBox(number: chatData['notify'], boxSize: 17,),
                                )
                            ],
                          ),
                        ],
                      )
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}