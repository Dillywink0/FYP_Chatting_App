import 'package:flutter/material.dart';

class FontSizeProvider extends ChangeNotifier {
  double _fontSize = 16.0;

  double get fontSize => _fontSize;

  void increaseFontSize() {
    _fontSize += 2.0;
    notifyListeners();
  }
}
