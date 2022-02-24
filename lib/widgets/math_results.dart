// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors

import '../controllers/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'line_separator.dart';
import 'main_result.dart';
import 'sub_result.dart';

class MathResults extends StatelessWidget {
  final calculatorCtrl = Get.find<CalculatorController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          SubResult(text: '${calculatorCtrl.firstNumber}'),
          SubResult(text: '${calculatorCtrl.operation}'),
          SubResult(text: '${calculatorCtrl.secondNumber}'),
          LineSeparator(),
          MainResultText(text: '${calculatorCtrl.mathResult}'),
        ],
      ),
    );
  }
}
