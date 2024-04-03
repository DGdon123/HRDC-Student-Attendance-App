import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  bool _dialogAlreadyShown = false;

  bool get dialogAlreadyShown => _dialogAlreadyShown;

  void setDialogAlreadyShown(bool value) {
    _dialogAlreadyShown = value;
    notifyListeners();
  }
}