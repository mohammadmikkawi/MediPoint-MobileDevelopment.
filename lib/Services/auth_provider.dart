import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _uid;

  String? get uid => _uid;

  void setUid(String uid) {
    _uid = uid;
    notifyListeners();
  }
}