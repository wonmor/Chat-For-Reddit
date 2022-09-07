
import 'package:chat_firebase/services/auth.dart';
import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/utils/data.dart';
import 'package:chat_firebase/widgets/custom_image.dart';
import 'package:chat_firebase/widgets/setting_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({ Key? key }) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  AuthService service = AuthService();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

   Widget getBody() {
    return 
    SingleChildScrollView(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 30,
                    ),
                    CustomImage(
                      profile, isSVG: false,
                      width: 80, height: 80,
                    ),
                    Container(
                      width: 30,
                      child: Icon(Icons.edit_road_outlined, color: Colors.black87,),
                    )
                  ],
                ),
                SizedBox(height: 15,),
                Text(_firebaseAuth.currentUser?.displayName ?? "Sangvaleap",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 8,),
                Text(_firebaseAuth.currentUser?.email ?? "@sangvaleap",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40,),
          SettingItem(title: "Appearance", leadingIcon: Icons.dark_mode_outlined, leadingIconColor: Colors.lightBlue,
            onTap: (){}
          ),
          SizedBox(height: 10),
          SettingItem(title: "Notification", leadingIcon: Icons.notifications_outlined, leadingIconColor: Colors.red,
            onTap: (){}
          ),
          SizedBox(height: 10),
          SettingItem(title: "Privacy", leadingIcon: Icons.privacy_tip_outlined, leadingIconColor: Colors.green,
            onTap: (){}
          ),
          SizedBox(height: 10),
          SettingItem(title: "Change Password", leadingIcon: Icons.lock_outline_rounded, leadingIconColor: Colors.orange,
            onTap: (){}
          ),
          SizedBox(height: 10),
          SettingItem(title: "Log Out", leadingIcon: Icons.logout_outlined, leadingIconColor: Colors.grey.shade400,
            onTap: (){
              showConfirmLogout();
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }


  showConfirmLogout(){
    showCupertinoModalPopup(
      context: context, 
      builder: (context) =>
        CupertinoActionSheet(
          message: Text("Would you like to log out?"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: (){
                service.logOut();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), 
                (route) => false);
              },
              child: Text("Log Out", style: TextStyle(color: secondary),),
            )
          ],
          cancelButton: 
            CupertinoActionSheetAction(child:
              Text("Cancel"),
              onPressed: (){
               Navigator.of(context).pop();
              },
            )
        )
    );
  }

}
