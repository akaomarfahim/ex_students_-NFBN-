import 'package:flutter/material.dart';

class RecipientProvider with ChangeNotifier {
  String _recipient = '';

  String get recipient => _recipient;

  void setSearchKey(String key) {
    _recipient = key;
    notifyListeners();
  }

  void clearRecipient() {
    _recipient = '';
    notifyListeners();
  }
}
