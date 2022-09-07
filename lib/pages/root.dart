import 'package:chat_firebase/pages/chat.dart';
import 'package:chat_firebase/pages/setting.dart';
import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/widgets/bottombar_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';

class RootApp extends StatefulWidget {
  const RootApp({ Key? key }) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return auth.currentUser != null ? goHome() : LoginPage();
  }

  int activeTab = 0;
  goHome() {
    return Scaffold(
      backgroundColor: appBgColor,
      bottomNavigationBar: getBottomBar(),
      body: getBarPage()
    );
  }

  Widget getBottomBar() {
    return Container(
      alignment: Alignment.center,
      height: 55, width: double.infinity,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: bottomBarColor,
        borderRadius: BorderRadius.circular(30),
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(25), 
        //   topRight: Radius.circular(25)
        // ), 
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.1),
            blurRadius: .5,
            spreadRadius: .5,
            offset: Offset(0, 1)
          )
        ]
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BottomBarItem(Icons.home_rounded, "", isActive: activeTab == 0, activeColor: primary,
              onTap: () {
                setState(() {
                  activeTab = 0;
                });
              },
            ),
            BottomBarItem(Icons.list_rounded, "", isActive: activeTab == 1, activeColor: primary,
              onTap: () {
                setState(() {
                  activeTab = 1;
                });
              },
            ),
            BottomBarItem(Icons.person_rounded, "", isActive: activeTab == 2, activeColor: primary,
              onTap: () {
                setState(() {
                  activeTab = 2;
                });
              },
            ),
          ]
        ),
    );
  }

  Widget getBarPage(){
    return 
      IndexedStack(
        index: activeTab,
        children: <Widget>[
          HomePage(),
          ChatPage(),
          SettingPage()
        ],
      );
  }
}