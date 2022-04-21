
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
    print('all variables::');
    print(widget._savedWords);
    var user = Provider.of<currentUser>(context);
    print('line 70 ');
    print(user.userEmail);
    return Container(
        color: Colors.white,
        child: user.userEmail == null
            ? homeScreen(updateFsFunc : updateData, updateFunc : updateVariables,
            savedWords : widget._savedWords, email : null, wordsSuggestions: widget._wordsSuggestions,
            savedList: widget._savedList)
            : userModeScreen(
              updateFsFunc: updateData, email: user.userEmail.toString(), savedWords: widget._savedWords,
            savedList: widget._savedList, wordsSuggestions: widget._wordsSuggestions,updateFunc: updateVariables,)

    );/*
      if(widget._currentUser == null){
//setState() or markNeedsBuild() called during build.
        return homeScreen(updateFsFunc : updateData, updateFunc : updateVariables,
            savedWords : widget._savedWords, email : widget._currentUser, wordsSuggestions: widget._wordsSuggestions,
            savedList: widget._savedList);
        /*
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ( ),),);*/
      }
      return userModeScreen(updateFsFunc: updateData, email: widget._currentUser.toString());
*/
  }

  updateData(email) async{
    print('line 98 arrived');
    print(email);
    if(email == null) return;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    print("line 95 widget.savedwords is:: ");
    print(widget._savedList);
    Map<String, dynamic> data = {"favorites":FieldValue.arrayUnion(widget._savedList)};
    _firestore = FirebaseFirestore.instance;
    await _firestore.collection('Users').doc(email).set(data,SetOptions(merge : false));
  }

  updateVariables(val1, val2, val3){
   /* print('hello updating::');
    print('val1:');
    print(val1);
    print(widget._savedList);*/
    setState(() {
      widget._savedList = val1;
      widget._savedWords = val2;
      if(val3 != null) widget._wordsSuggestions = val3;
    });
    /*
    print('val2:');
    print(val2);
    print(widget._savedWords);
    */

}


}



/*





class RandomWords extends StatefulWidget{
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}


class _RandomWordsState extends State<RandomWords> {
  @override
  var _suggestions = <WordPair>[];
  var _saved = <WordPair>{};
  var _savedList =[];
  final _biggerFont = const TextStyle(fontSize: 18); // NEW
  bool isLoggedIn = false;
  String? _currentUser = 'kalamari';
  bool loaded = false;
  bool p = true;

  void updateData() async{
    if(_currentUser == null) return;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Map<String, dynamic> data = {"favorites":FieldValue.arrayUnion(_savedList)};
    _firestore = FirebaseFirestore.instance;
    await _firestore.collection('Users').doc(_currentUser).set(data,SetOptions(merge : false));
  }

  variablesUpdate(listVar, setVar) {
    setState(() {
      _savedList = listVar;
      _saved = setVar;
    });
  }

  statusUpdate(val){
    print(p);
    p = val;
    print(p);
  }
  Widget _buildRow(WordPair pair) {

    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.star : Icons.star_border,
        color: alreadySaved ? Colors.deepPurple : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ), // ... to here.
      onTap: () async{      // NEW lines from here...
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
            _savedList.remove(pair.asSnakeCase);
          }
          else {
            _saved.add(pair);
            _savedList.add(pair.asSnakeCase);
          }});
        updateData();
      },);}


  void _pushSaved() async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          bool _lightIsOn = false;
          //bool p =false;
          double y = 100;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: p?userModeScreen(updateFsFunc:statusUpdate,email: this._currentUser.toString(),):userModeScreen(
                updateFsFunc:statusUpdate,email: this._currentUser.toString(),)
          );},),);
  }


  void _pushSaved2() async{
    String? result = await Navigator.push(context,
      MaterialPageRoute(
        builder:(context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Login'),
              centerTitle: true,
            ),
            body:logInPage(),);

        },),);
    var cloudWords =  await FirebaseFirestore.instance.collection('Users').doc(result).
    get().then((querySnapshot) {return querySnapshot.data();});
    setState (() {
      _currentUser = result;
      if(result != null){
        if(cloudWords != null) {
          _savedList = _savedList + cloudWords['favorites'];
        }
        _savedList = _savedList.toSet().toList();
        for(int i = 0; i < _savedList.length; i++){
          String temp = _savedList[i].toString();
          var tempList = temp.split('_');
          String first = tempList[0];
          String second = tempList[1];
          WordPair tempWord = WordPair(first, second);
          if(!_saved.contains(tempWord)){
            _saved.add(tempWord);
          }
        }
      }});
    if(_savedList.length > 0 ){
      updateData();
    }
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider();
        }
        final index = i ~/ 2;
        if (index >= _suggestions.length) {//index
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);//
      },
    );
  }




  Widget build(BuildContext context) {
    return Scaffold (
        appBar: AppBar(
            title: const Text('Startup Name Generator'),
            actions: [
              IconButton(
                icon: const Icon(Icons.list),
                onPressed: _pushSaved,
                tooltip: 'Saved Suggestions',
              ),
              _currentUser != null ? IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed:() async {
                  setState(() {
                    _currentUser = null;
                    _savedList = [];
                    _saved = <WordPair>{};
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Successfully logged out'),));
                },
                tooltip: 'login',
              ) : IconButton(
                icon: const Icon(Icons.login),
                onPressed: _pushSaved2,
                tooltip: 'login',),
            ]),
        body:_currentUser != null ? userModeScreen(updateFsFunc: statusUpdate, email: _currentUser.toString()):
        _buildSuggestions(),);                                     // ... to here.
  }
}*/