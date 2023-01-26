import 'package:flutter/material.dart';
import 'package:ride_kaki/screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ride Kaki',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ResultScreen(),
    );
  }
}
