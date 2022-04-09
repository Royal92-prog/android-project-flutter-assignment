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

      print("Line 58");
      await _firestore.collection('Users').doc(email.toString()).set(data,SetOptions(merge : true));
      print('line32');
      await FirebaseFirestore.instance.collection('Users').doc(email.toString()).
      get().then((querySnapshot) {return querySnapshot.data();});

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



class GetUserName extends StatelessWidget {
  final String? documentId;

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    //CollectionReference users = FirebaseFirestore.instance.collection('users');

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(documentId).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        print("HEREEEEE");
        print(this.documentId);
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text("Full Name: ${data['favorites']}");
        }

        return Text("loading");
      },
    );
  }
}
