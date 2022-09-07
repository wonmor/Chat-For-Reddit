import 'dart:math';
import 'package:chat_firebase/model/message.dart';
import 'package:chat_firebase/utils/data.dart';
import 'package:chat_firebase/utils/global.dart';
import 'package:chat_firebase/widgets/custom_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ChatRoomBox extends StatelessWidget {
  ChatRoomBox({ Key? key, required this.message}) : super(key: key);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return 
      Container(
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
        child: getGroupChat()
      );
  }

  getPersonalChat(){
    return
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: message.userId == _firebaseAuth.currentUser!.uid ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 300),
            padding: EdgeInsets.fromLTRB(15, 7, 15, 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20) ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: this.message.message, style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black),),
                      TextSpan(text: "   "),
                      TextSpan(text: getTimeAgo(this.message.createdAt), style: TextStyle(fontSize: 13, color: Colors.grey),),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      );
  }

  getGroupChat(){
    return message.userId != _firebaseAuth.currentUser!.uid ?
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImage(
            // this.message.userId.toString(), 
            chatsData[this.message.message.length % 5]["image"].toString() , isSVG: false,
            width: 40, height: 40,
          ),
          SizedBox(width: 10,),
          Container(
            constraints: BoxConstraints(maxWidth: 280),
            padding: EdgeInsets.fromLTRB(15, 7, 15, 10),
            decoration: BoxDecoration(
              color: Color(Random().nextInt(0xffffffff)).withAlpha(20),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20) ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(this.message.userName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),),
                // SizedBox(height: 5,),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: this.message.message, style: TextStyle(fontSize: 15, color: Colors.black, height: 1.5),),
                      TextSpan(text: "    " + getTimeAgo(this.message.createdAt), style: TextStyle(fontSize: 13, color: Colors.grey),),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      )
      : 
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 300),
            padding: EdgeInsets.fromLTRB(15, 7, 15, 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20) ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(this.message.userName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),),
                // SizedBox(height: 5,),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: this.message.message, style: TextStyle(fontSize: 15, color: Colors.black, height: 1.5),),
                      TextSpan(text: "    " + getTimeAgo(this.message.createdAt), style: TextStyle(fontSize: 13, color: Colors.grey),),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      );
  }

}