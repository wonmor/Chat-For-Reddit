
import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/utils/data.dart';
import 'package:chat_firebase/widgets/chat_item.dart';
import 'package:chat_firebase/widgets/custom_image.dart';
import 'package:chat_firebase/widgets/group_slider.dart';
import 'package:chat_firebase/widgets/story_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return  getBody();
  }

  getBody(){
    return SingleChildScrollView(
      child: Column(children: [
          getHeader(),
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
            alignment: Alignment.centerLeft,
            child: Text("Stories", 
              style: TextStyle(fontSize: 21, color: Colors.black87, fontWeight: FontWeight.w600)
            ,)
          ),
          getStories(),
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  child: Text("Groups", 
                    style: TextStyle(fontSize: 21, color: Colors.black87, fontWeight: FontWeight.w600)
                  ),
                ),
                Text("See all", 
                  style: TextStyle(fontSize: 15, color: primary, fontWeight: FontWeight.w400)
                ),
                Icon(Icons.arrow_right, color: primary)
              ],
            )
          ),
          getGroups(),
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
            alignment: Alignment.centerLeft,
            child: Text("Recents", 
              style: TextStyle(fontSize: 21, color: Colors.black87, fontWeight: FontWeight.w600)
            ,)
          ),
          getRecents(),
        ]
      ),
    );
  }

  getHeader(){
    return
      Container(
        padding: EdgeInsets.fromLTRB(20, 60, 15, 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)
          )
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_firebaseAuth.currentUser?.displayName ?? "N/A",
                      style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 5,),
                    Text("Let's reach your friends!", 
                      style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                CustomImage(profile, isSVG: false,
                  width: 40, height: 40, trBackground: true, borderColor: primary,
                ),
              ],
            ),
          ],
        ),
      );
  }

  getStories(){
    return 
      SingleChildScrollView(
        padding: EdgeInsets.all(10),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(chatsData.length, (index) => 
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: StoryBox(data: chatsData[index])
            ) 
          )
        ),
      );
  }

  getGroups(){
    return
      Container(
        padding: EdgeInsets.only(top: 10, bottom: 0),
        child: GroupSlider(groups: groupChatsData)
      );
  }

  getRecents(){
    return
      ListView(
        padding: EdgeInsets.all(10),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: List.generate(3, 
        (index) => ChatItem(chatsData[index],
            onTap: (){
            },
          )
        )
    );
  }

}