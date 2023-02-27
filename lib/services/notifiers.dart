import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  static bool _isDark = true;

  Brightness currentTheme() {
    return _isDark ? Brightness.dark : Brightness.light;
  }

  bool get isDark => _isDark;

  void setTheme(bool isDark) {
    _isDark = isDark;
    notifyListeners();
  }

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
