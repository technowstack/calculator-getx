// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, duplicate_ignore, must_be_immutable

import 'package:flutter/material.dart';
import 'screens/calculator_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      // ignore: prefer_const_constructors
      home: CalculatorScreen(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
    );
  }
}
