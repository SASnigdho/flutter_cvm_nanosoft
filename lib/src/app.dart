import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'core/constants/app_colors.dart';
import 'features/theme/presentation/cubit/theme_cubit.dart';
import 'routes/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state.mode.name == ThemeMode.dark.name;

        log('$runtimeType:: Theme($isDark)');

        return GestureDetector(
          // Dismiss keyboard when tap outside of text field.
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),

          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.routerConfig,

            // EasyLoading dialog builder.
            builder: EasyLoading.init(),

            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
              useMaterial3: true,
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.grey, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.red, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.red, width: 1),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
