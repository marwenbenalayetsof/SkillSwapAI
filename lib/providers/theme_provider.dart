import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark) { _loadTheme(); }
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = (prefs.getBool('isDarkMode') ?? true) ? ThemeMode.dark : ThemeMode.light;
  }
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await prefs.setBool('isDarkMode', state == ThemeMode.dark);
  }
}
