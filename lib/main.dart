import 'package:flutter/material.dart';
import 'package:newmercal/views/home_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Methods',
      theme: ThemeData.dark(),
      home: const HomeView(),
    );
  }
}
