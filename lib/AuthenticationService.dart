import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


/*
class Data {

  var savedWords;

  Data(this.savedWords);

  Map<String, dynamic> toJson() {
    return {
      'savedWords':  savedWords
    };}
    factory Data.fromJson(Map<String, dynamic> parsedJson) {
      return Data(savedWords : parsedJson['savedWords']);
    }

}

*/

class AuthenticationService {//extends ChangeNotifier
  final FirebaseAuth _firebaseAuth ;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthenticationService(this._firebaseAuth);
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future <User?> signIn({required var savedWords, required String email, required String password}) async{
    //print(email);
    //print(password);
    try {
          print("line20__________");
          FirebaseFirestore _firestore = FirebaseFirestore.instance;
          await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
         /* final currentWords  = _firestore.collection('users').doc(_firebaseAuth.currentUser?.uid).snapshots().data!.data() as Map<String, dynamic>
          if(currentWords.isEmpty == false){
            final firstMap = {"1":"2"};
            final secondMap = {"2":"3"};

            final thirdMap = {
              ...currentWords.snapshots,
              ...secondMap,
            };
            new  CombinedMapView(currentWo
          }*/
          //await _firestore.collection("Users").doc(_firebaseAuth.currentUser?.uid).get(['favoriteWords'])
          print("AuthService line 37");
          print(savedWords);
          Map<String, dynamic> data = {"favorites":FieldValue.arrayUnion(savedWords)};
          //Map<String, dynamic> result = new Map();
          /*for(int i = 0; i < savedWords.length; i++) {
            String temp = i.toString();
            print(temp);
            result[temp] = savedWords[i].toString();

            }*/
           // print(result);
         // print("AuthService line 35");
          //print(result);
           _firestore = FirebaseFirestore.instance;
          _firestore.collection('users').doc(_firebaseAuth.currentUser?.uid).get().
          then((DocumentSnapshot documentSnapshot) async {
            if (documentSnapshot.exists) {
              dynamic res = documentSnapshot.get(['favoriteWords']);
              print("res is   ");
              print(res);
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

