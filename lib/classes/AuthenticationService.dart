import 'package:firebase_auth/firebase_auth.dart';


class AuthenticationService {
  final FirebaseAuth _firebaseAuth ;
  AuthenticationService(this._firebaseAuth);
  Stream <User?> get authStateChanges => _firebaseAuth.authStateChanges();
  Future <User?> signIn({required String email, required String password}) async{

    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
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


