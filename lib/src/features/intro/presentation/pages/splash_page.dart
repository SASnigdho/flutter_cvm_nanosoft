import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/styles.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../routes/app_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    _navigatePage(context);

    return Scaffold(
      body: const Center(child: AppLogo()),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: Styles.padding),
        child: Text(
          'https://website.nanoit.biz',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }

  void _navigatePage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));

      if (!context.mounted) return;

      context.pushReplacementNamed(AppRouter.customers);

      /* final user = await LocalStorage().getUser();

      if (!context.mounted) return;

      if (user == null) {
        context.pushReplacementNamed(AppRouter.signIn);
      } else {
        context.pushReplacementNamed(AppRouter.home);
      } */
    });
  }
}
