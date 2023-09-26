import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}