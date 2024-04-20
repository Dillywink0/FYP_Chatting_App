import 'package:flutter/material.dart';

class ColorProvider extends ChangeNotifier {
  Color _selectedColor = Colors.blue;

  Color get selectedColor => _selectedColor;

  set selectedColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }
}
