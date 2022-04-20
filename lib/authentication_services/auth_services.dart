import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthServices with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = "";
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future registerNewUsers({var name, var email, var password}) async {
    setLoading(true);
    try {
      UserCredential authResult = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'displayName': name,
        'email': email,
        'password': password,
      });

      await user!.sendEmailVerification();
      setLoading(false);
      return user;
    } on SocketException {
      setLoading(false);
      setMessage("No internet, please connect to the internet");
    } catch (e) {
      setLoading(false);
      setMessage(e.toString());
    }
    notifyListeners();
  }

  Future loginUsers(String email, String password) async {
    setLoading(true);
    try {
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = authResult.user;

      if (!user!.emailVerified) {
        setLoading(false);
        await user.sendEmailVerification();
        return user;
      } else {
        setLoading(false);
        return user;
      }
    } on SocketException {
      setLoading(false);
      setMessage("No internet, please connect to the internet");
    } catch (e) {
      setLoading(false);
      setMessage(e.toString());
    }
    notifyListeners();
  }

  Future logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      // final snackBar = SnackBar(content: Text(e.toString()));
      // ScaffoldMessenger.of(context!).showSnackBar(snackBar);
    }
  }

  Future resetPassword(email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  void setMessage(message) {
    _errorMessage = message;
    notifyListeners();
  }

  Stream<User?> get user =>
      firebaseAuth.authStateChanges().map((event) => event);
}
