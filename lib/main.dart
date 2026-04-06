import 'package:chat_firebase/pages/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SubChat',
      theme: ThemeData(
        primaryColor: primary,
        scaffoldBackgroundColor: appBgColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: appBgColor,
          elevation: 0,
          iconTheme: IconThemeData(color: primary),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: RootApp(),
    );
  }
}
