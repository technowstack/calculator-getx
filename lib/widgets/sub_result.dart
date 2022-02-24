// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';

class SubResult extends StatelessWidget {
  final String text;

  const SubResult({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerRight,
      child: Text(this.text,
          // ignore: prefer_const_constructors
          style: TextStyle(
            fontSize: 30,
          )),
    );
  }
}
