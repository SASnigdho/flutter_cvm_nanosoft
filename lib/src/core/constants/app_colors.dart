import 'package:flutter/material.dart';

class AppColors {
  // static const Color primary = Color(0xFFAC9DFB);
  // static const Color primary = Color(0xFF53B175);
  static const Color primary = Color(0xFFF15A25);

  static const Color white = Color(0xFFF6F7F8);
  static const Color red = Colors.red;
  static const Color grey = Colors.grey;
  static const Color black = Colors.black;
  static const Color green = Colors.green;
  static const Color amber = Colors.amber;

  static const Color background = Color(0xFFF6F7F8);

  static const linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primary],
    // Optional: Specify stops for each color
    stops: [0.2, 0.8],
    // Optional: Transform the gradient (e.g., rotate it)
    transform: GradientRotation(0.7),
    tileMode: TileMode.mirror,
  );
}
