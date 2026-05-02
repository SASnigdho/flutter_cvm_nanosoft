import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Nanosoft',
        style: DefaultTextStyle.of(context).style.copyWith(
          color: AppColors.primary,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        children: const <TextSpan>[
          TextSpan(
            text: 'CVM',
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
