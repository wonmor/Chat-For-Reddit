
import 'package:chat_firebase/utils/data.dart';
import 'package:chat_firebase/widgets/chat_item.dart';
import 'package:chat_firebase/widgets/round_textbox.dart';
import 'package:flutter/material.dart';

import 'chat_room.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({ Key? key }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  getBody(){
    return SingleChildScrollView(
        child: Column(children: [
            getHeader(),
            getChats(),
          ]
        ),
      );
  }

  getHeader(){
    return
      Container(
        padding: EdgeInsets.fromLTRB(20, 60, 15, 5),
        decoration: BoxDecoration(
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Chats", 
                      style: TextStyle(fontSize: 28, color: Colors.black87, fontWeight: FontWeight.w600)
                    ,)
                  ),
                ),
                Icon(Icons.add_rounded, color: Colors.black),
              ],
            ),
            SizedBox(height: 15),
            Container(
              child: RoundTextBox(),
            ),
          ],
        )
      );
  }

  getChats(){
    return
      ListView(
        padding: EdgeInsets.all(10),
        shrinkWrap: true,
        children: List.generate(chatsData.length, 
        (index) => ChatItem(chatsData[index],
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: 
                (context) => ChatRoomPage(roomData: chatsData[index],), fullscreenDialog: true));
            },
          )
        )
    );
  }
}