// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:calculator_getx/widgets/calc_buttons.dart';
import 'package:calculator_getx/widgets/math_results.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculator_controller.dart';

class CalculatorScreen extends StatelessWidget {
  final calculatorCtrl = Get.put(CalculatorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
              child: Container(
        constraints: BoxConstraints(maxWidth: GetPlatform.isWeb ? 420 : 600),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<CalculatorController>(
                builder: (controller) => IconButton(
                  icon: Icon(
                    controller.isDarkMode.value
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  onPressed: () => controller.toggleDarkMode(),
                ),
              ),
              MathResults(),
              CalculatorButtons(),
              if (GetPlatform.isWeb) SizedBox(height: 22),
            ],
          ),
        ),
      ))),
    );
  }
}
