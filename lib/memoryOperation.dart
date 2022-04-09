import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUser  {//extends StatelessWidget
  final String email;
  final String password;
  final savedWords;

  AddUser(this.email, this.password, this.savedWords);
  Future<void> addUser() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // Call the user's CollectionReference to add a new user
     return users.add({
      'email': email, // John Doe
      'password': password, // Stokes and Sons
      'favoriteWords': savedWords // 42
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
  Future<DocumentSnapshot> _getUser() {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return _firestore.collection('users').doc(email).get();
  }
/*
  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection




    return addUser();
    TextButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }*/
}

