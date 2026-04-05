import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/widgets/setting_item.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: primary,
                    child: const Icon(Icons.reddit, size: 48, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Chat for Reddit',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'iMessage-style Reddit browser',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SettingItem(
              title: "Appearance",
              leadingIcon: Icons.dark_mode_outlined,
              leadingIconColor: Colors.lightBlue,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            SettingItem(
              title: "About",
              leadingIcon: Icons.info_outline,
              leadingIconColor: Colors.grey,
              onTap: () {},
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
