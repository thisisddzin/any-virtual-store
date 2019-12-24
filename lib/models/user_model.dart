import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  void signUp({
    @required Map<String, dynamic> userData, 
    @required String pass, 
    @required VoidCallback onSuccess, 
    @required VoidCallback onFail
  }) {
    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
      email: userData['email'],
      password: pass
    ).then((authResult) async {
      firebaseUser = authResult.user;

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((err) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));

    isLoading = false;
    notifyListeners();
  }

  void recoverPass() {

  }

  void signOut () async {
    await _auth.signOut();
    firebaseUser = null;
    userData = Map();

    notifyListeners();
  }

  bool isLoggedIn(){
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance.collection('users').document(firebaseUser.uid).setData(userData);
  }

}