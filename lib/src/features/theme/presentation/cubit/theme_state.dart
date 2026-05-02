part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeMode mode;

  const ThemeState({this.mode = ThemeMode.system});

  ThemeState copyWith({final ThemeMode? themeMode}) {
    return ThemeState(mode: themeMode ?? mode);
  }

  @override
  List<Object> get props => [mode];
}
