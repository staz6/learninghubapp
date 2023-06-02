import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool? _loggedIn;
  bool? _isCreator;

  bool? get loggedIn => _loggedIn;
  bool? get isCreator => _isCreator;

  Future<DocumentSnapshot> _getCreatorDocument() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('creators')
          .doc(user.uid)
          .get();
    }
    return Future.error('User not logged in');
  }

  Future<DocumentSnapshot> _getUserDocument() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    }
    return Future.error('User not logged in');
  }

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) async {
      _loggedIn = user != null;
      if (_loggedIn ?? false) {
        try {
          DocumentSnapshot creatorDoc = await _getCreatorDocument();
          DocumentSnapshot userDoc = await _getUserDocument();
          _isCreator = creatorDoc.exists;
        } catch (error) {
          _isCreator = false;
        }
      } else {
        _isCreator = false;
      }
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
