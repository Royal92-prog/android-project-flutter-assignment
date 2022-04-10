import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:hello_me2/loginPage.dart';
import 'package:hello_me2/AuthenticationService.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hello_me2/fireStoreServices.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
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
        home: RandomWords(),
      ),);
  }
}


class RandomWords extends StatefulWidget {
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
  String? _currentUser = null;
  bool loaded = false;

  Widget _buildRow(WordPair pair) {

    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(     // NEW from here...
        alreadySaved ? Icons.star : Icons.star_border,
        color: alreadySaved ? Colors.deepPurple : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ), // ... to here.
      onTap: () {      // NEW lines from here...
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
            _savedList.remove(pair.asSnakeCase);
          } else {
            _saved.add(pair);
            _savedList.add(pair.asSnakeCase);
          }
        });
      },               // ... to here.
    );
  }

  Container _buildFavoriteList() {
    final tiles = _saved.map(
          (pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      },
    );
    final allKept = _saved.toList();
    final divided = tiles.isNotEmpty
        ? ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList(): <Widget>[];

    return Container(
      child: divided.length > 0
          ? ListView.builder(
        itemCount: divided.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            confirmDismiss: (DismissDirection horizontal) {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Delete Suggestion'),
                      content: Text('are you sure you want to delete ${allKept[index]} from your saved suggestions?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            setState(() {
                              _saved.remove(allKept[index]);
                              _savedList.remove(allKept[index].asSnakeCase);
                            });
                          }, style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.deepPurple,

                        ),
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('no'),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.deepPurple,
                            ),
                        )
                      ],
                    );
                  });
            },
            background: Container(
              color: Colors.deepPurple,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    Text('Delete Suggestion',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),),
            child: divided[index],
            key: UniqueKey(),
            direction: DismissDirection.horizontal,
            secondaryBackground: Container(
              color: Colors.deepPurple,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    Text('Delete Suggestion',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),),);},)
          : Center(child: Text('No Items')),);
  }


  void _pushSaved() async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          print("Line 191");
          print(_currentUser);
          print(loaded);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: _buildFavoriteList(),);
        },
      ),);
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
            body:logInPage(_savedList),);

        },),);
    print(result);
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
        if(!_suggestions.contains(tempWord)){
          _suggestions.insert(0,tempWord);
        }
        if(!_saved.contains(tempWord)){
          print("Line 248");
          _saved.add(tempWord);
        }
      }
    }});}

  Widget _buildSuggestions() {
    return ListView.builder(
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider();
        }
        final index = i ~/ 2;
        if (index>= _suggestions.length) {//index
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
                  FirebaseFirestore _firestore = FirebaseFirestore.instance;
                  await context.read<AuthenticationService>().signOut();
                  _savedList.remove("pot_form");
                  _savedList.remove("tour_math");
                  _savedList.remove("shell_math");
                  Map<String, dynamic> data = {"favorites":FieldValue.arrayUnion(_savedList)};
                  _firestore = FirebaseFirestore.instance;
                  await _firestore.collection('Users').doc(_currentUser).set(data,SetOptions(merge : false));
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
        body:_buildSuggestions());                                      // ... to here.
  }
}