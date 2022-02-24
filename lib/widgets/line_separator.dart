// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LineSeparator extends StatelessWidget {
  const LineSeparator({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 2,
      color: Color(0xffD0CFCF).withOpacity(0.4),
      margin: EdgeInsets.symmetric(vertical: 10),
    );
  }
}