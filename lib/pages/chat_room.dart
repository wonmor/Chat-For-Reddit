import 'package:chat_firebase/model/message.dart';
import 'package:chat_firebase/services/message.dart';
import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/widgets/chat_room_box.dart';
import 'package:chat_firebase/widgets/custom_dialog.dart';
import 'package:chat_firebase/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  ChatRoomPage({ Key? key, required this.roomData }) : super(key: key);
  final roomData;
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  bool isLoading = false;
  MessageService service = MessageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        title: 
          Column(
            children: [
              Text("Flutter Community"),
            ],
          ),
      ),
      body:  SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 90),
          child: getChats()
        ),
      ),
      floatingActionButton: getBottom(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  getChats(){
    return StreamBuilder<QuerySnapshot>(
      stream: service.getMessageStream(10),
      builder: (context, snapshot){
        if(!snapshot.hasData) {
          return Container();
        }
        var data = snapshot.data!.docs;
        print(data.length);
      //  return ListView.builder(itemBuilder: (context, index) {
      //    var msg = Message.fromJson(data[index].data() as Map<String, dynamic>);
      //    return ChatRoomBox(message: msg);
      //  }, shrinkWrap: true, itemCount: data.length);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(data.length, (index) { 
          var msg = Message.fromJson(data[index].data() as Map<String, dynamic>);
          return ChatRoomBox(message: msg);
        }),
      );
    });
  }

  getBottom(){
    return 
      Container(
        padding: EdgeInsets.only(left: 0, right: 5),
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(children: [
          IconButton(
            onPressed: () {
            },
            icon: Icon(Icons.add, color: primary, size: 30,)
          ),
          Expanded(
            child: Container(
              child: CustomTextField(
                controller: messageController,
                hintText: "Write your message",
              )
            ),
          ),
          IconButton(
            onPressed: () {
              sendMessage();
            },
            icon: Icon(Icons.send_rounded, color: isLoading ? Colors.grey : primary, size: 35,)
          )
        ],),
      );
  }

  sendMessage() async{
    if(isLoading) return;
    setState(() {
      isLoading = true;
    });

    var res = await service.sendMessage(messageController.text);

    setState(() {
      isLoading = false;
    });
    if(res["status"] == true){
      messageController.clear();
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context){
        return CustomDialogBox(title: "Chat", descriptions: res["message"],);
        }
      );
    }
  }

}