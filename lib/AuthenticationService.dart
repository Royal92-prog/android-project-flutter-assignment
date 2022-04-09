import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class AuthenticationService {
  final FirebaseAuth _firebaseAuth ;
  AuthenticationService(this._firebaseAuth);
  Stream <User?> get authStateChanges => _firebaseAuth.authStateChanges();
  Future <User?> signIn({required var savedWords, required String email, required String password}) async{

    try {

          FirebaseFirestore _firestore = FirebaseFirestore.instance;
          await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

          Map<String, dynamic> data = {"favorites":FieldValue.arrayUnion(savedWords)};
           _firestore = FirebaseFirestore.instance;
          _firestore.collection('users').doc(_firebaseAuth.currentUser?.uid).get().
          then((DocumentSnapshot documentSnapshot) async {
            if (documentSnapshot.exists) {
              dynamic res = documentSnapshot.get(['favoriteWords']);
              _firestore.collection('users').doc(_firebaseAuth.currentUser?.uid).update(
                  {'favoriteWords': FieldValue.arrayUnion(['res', 'savedWords'])});
            }
            else
            {
              print("Line 58");
              await _firestore.collection("Users").doc(_firebaseAuth.currentUser?.uid).set(data,SetOptions(merge : true));

            }
            });

          return _firebaseAuth.currentUser;

    }

    on FirebaseAuthException catch(e){
      return null;
    }
  }

  Future<void> signOut() async {

    await _firebaseAuth.signOut();
  }
}

