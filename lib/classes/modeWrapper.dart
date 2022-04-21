
import 'package:Hw3/screens/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:Hw3/classes/AuthenticationService.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Hw3/screens/userScreen.dart';
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider<currentUser>(
          create: (_) => currentUser(),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges, initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'Startup Name Generator',

        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        home: modesWrapper()//RandomWords(),
      ),);
  }
}

class currentUser with ChangeNotifier {
  String? userEmail = null;//'royal@gmail.com'

  void setUser(String? val) {
    userEmail = val;
    notifyListeners();
  }
}

class modesWrapper extends StatefulWidget{
  modesWrapper({Key? key}) : super(key: key);
  var _wordsSuggestions = <WordPair>[];
  var _savedWords = <WordPair>{};
  var _savedList = [];
  //String? _currentUser = null;

  @override
  State<modesWrapper> createState() => _modesWrapperState();
}


class _modesWrapperState extends State<modesWrapper> {

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<currentUser>(context);
    return Container(
        color: Colors.white,
        child: user.userEmail == null
            ? homeScreen(updateFsFunc : updateData, updateFunc : updateVariables,
            savedWords : widget._savedWords, email : null, wordsSuggestions: widget._wordsSuggestions,
            savedList: widget._savedList)
            : userModeScreen(
              updateFsFunc: updateData, email: user.userEmail.toString(), savedWords: widget._savedWords,
            savedList: widget._savedList, wordsSuggestions: widget._wordsSuggestions,updateFunc: updateVariables,)

    );
  }

  updateData(email) async{
    if(email == null) return;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Map<String, dynamic> data = {"favorites":FieldValue.arrayUnion(widget._savedList)};
    _firestore = FirebaseFirestore.instance;
    await _firestore.collection('Users').doc(email).set(data,SetOptions(merge : false));
  }

  updateVariables(val1, val2, val3){
    setState(() {
      widget._savedList = val1;
      widget._savedWords = val2;
      if(val3 != null) widget._wordsSuggestions = val3;
    });
  }
}
