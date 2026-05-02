import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(mode: ThemeMode.light)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final pref = await SharedPreferences.getInstance();
    final isDark = pref.getBool('IS_DARK') ?? false;

    setTheme(isDark == true ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> setTheme(ThemeMode mode) async {
    // AppTheme.setStatusBarAndNavigationBarColors(mode);
    emit(state.copyWith(themeMode: mode));

    final pref = await SharedPreferences.getInstance();
    await pref.setBool('IS_DARK', mode.name == ThemeMode.dark.name);
  }
}
