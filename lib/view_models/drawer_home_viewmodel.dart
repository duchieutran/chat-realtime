import 'package:flutter/cupertino.dart';

class DrawerHomeViewmodel with ChangeNotifier {
  bool _isOpen = false;
  double _xOffset = 0;
  double _yOffset = 0;

  bool get isOpen => _isOpen;

  double get xOffset => _xOffset;

  double get yOffset => _yOffset;

  void toggleDrawer() {
    _isOpen = !_isOpen;
    _xOffset = _isOpen ? 250 : 0;
    _yOffset = _isOpen ? 100 : 0;
    notifyListeners();
  }
}
