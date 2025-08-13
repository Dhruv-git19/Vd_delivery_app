import 'package:flutter/material.dart';

class NavigationBarProvider extends ChangeNotifier {
  bool _ismenuOpen = false;

  bool get ismenuOpen => _ismenuOpen;

  void toggleMenu() {
    _ismenuOpen = !_ismenuOpen;
    notifyListeners();
  }
}
