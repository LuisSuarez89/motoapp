import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/checklist_service.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final Ref ref;
  static const _key = 'is_dark_mode';

  ThemeModeNotifier(this.ref) : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final prefs = ref.read(sharedPreferencesProvider);
    final isDark = prefs.getBool(_key);
    if (isDark != null) {
      state = isDark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  void toggleTheme() {
    final isDark = state == ThemeMode.dark;
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
    state = newMode;
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setBool(_key, !isDark);
  }
}
