import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccentColorProvider extends ChangeNotifier {
  static const _accentColorKey = 'accent_color';

  Color _color = Colors.red;

  Color get color => _color;

  Future<void> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final colorValue = preferences.getInt(_accentColorKey);
      if (colorValue == null) {
        return;
      }

      _color = Color(colorValue);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> setColor(Color color) async {
    _color = color;
    notifyListeners();

    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setInt(_accentColorKey, color.value);
    } catch (_) {}
  }
}
