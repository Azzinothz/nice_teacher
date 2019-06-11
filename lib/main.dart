import 'package:flutter/material.dart';
import 'package:nice_teacher/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '好老师',
      theme: ThemeData(
        primarySwatch: Colors.purple
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: LoginPage()
    );
  }
}
