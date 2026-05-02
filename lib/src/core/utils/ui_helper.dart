import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../routes/app_router.dart';
import '../constants/app_colors.dart';

class UiHelper {
  static void initProgressDialog() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..maskColor = Colors.transparent
      ..userInteractions = false
      ..backgroundColor = AppColors.black
      ..indicatorColor = AppColors.primary
      ..textColor = AppColors.primary
      // ..indicatorWidget =
      //     Lottie.asset(Assets.lottieLoading4_2, height: 60, width: 60)
      ..indicatorSize = 80
      ..indicatorWidget = const CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 3,
      );
  }

  static void showProgressDialog() {
    if (!EasyLoading.isShow) EasyLoading.show(dismissOnTap: false);
  }

  static void dismissProgressDialog() {
    if (EasyLoading.isShow) EasyLoading.dismiss();
  }

  static void success(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      showCloseIcon: true,
      backgroundColor: AppColors.green,
    );

    ScaffoldMessenger.of(AppRouter.context!).showSnackBar(snackBar);
  }

  static void error(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      showCloseIcon: true,
      backgroundColor: AppColors.red,
    );

    ScaffoldMessenger.of(AppRouter.context!).showSnackBar(snackBar);
  }
}
