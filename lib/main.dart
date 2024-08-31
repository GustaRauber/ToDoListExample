import 'package:flutter/material.dart';
import 'package:livecoding/pages/homepage.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Coding Flutter',
      debugShowCheckedModeBanner: false,
      color: Colors.blue,
      theme: ThemeData(),
      home: const HomePage(),
    );
  }
}
