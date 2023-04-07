import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool? _loggedIn;

  bool? get loggedIn => _loggedIn;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _loggedIn = user != null;
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
