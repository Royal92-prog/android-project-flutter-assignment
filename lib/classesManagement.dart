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
    //final wordPair = WordPair.random(); // Add this line.
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
        theme: ThemeData(          // Add the 5 lines from here...
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
  final _suggestions = <WordPair>[];
  var _saved = <WordPair>{};
  var _savedList =[];
  final _biggerFont = const TextStyle(fontSize: 18); // NEW
  bool _isButtonDisabled = false;//false
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
            _savedList.remove(pair.asString);
          } else {
            _saved.add(pair);
            _savedList.add(pair.asString);
          }
        });
      },               // ... to here.
    );
  }

  Container _buildFavoriteList() {
    //Stream documentStream = FirebaseFirestore.instance.collection('users').doc('ABC123').snapshots();
    print(_currentUser);
    print("Printing Data");

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
          //print(z[index].title!.toString());
          //print(tiles);
          return Dismissible(
            confirmDismiss: (DismissDirection horizontal) {
              /*const snackBar2 = SnackBar(
                content: Text("Deletion is not implemented yet"),
              );ScaffoldMessenger.of(context).showSnackBar(snackBar2);*/
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Konfirmasi'),
                      content: Text('are you sure you want to delete ${allKept[index]} from your saved suggestions?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            //_saved.remove(tiles[allKept[index]]);
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('no'),
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
              ),),

          );
        },
      )
          : Center(child: Text('No Items')),
    );
  }



  void _pushSaved() async {

    Navigator.of(context).push(
      // Add lines from here...
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
          //return GetUserName(_currentUser);

        },//ListView(children: divided)
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

    setState (() {
      _currentUser = result;

      _saved = <WordPair>{};
    });}

  _callbackButton() {//async
    _isButtonDisabled = true;
    Navigator.pop(context);

    _isButtonDisabled = false;
  }


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
    //final wordPair = WordPair.random(); remove1
    //return Text(wordPair.asPascalCase); remove2
    return Scaffold (                     // Add from here...
        appBar: AppBar(
            title: const Text('Startup Name Generator'),
            // Add from here ...
            actions: [
              IconButton(
                icon: const Icon(Icons.list),
                onPressed: _pushSaved,
                tooltip: 'Saved Suggestions',
              ),
              _currentUser != null ? IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed:() async {
                  /*FirebaseFirestore _firestore = FirebaseFirestore.instance;
                  await _firestore.collection("Users").doc(_currentUser?.uid).
                  set({'favoriteWords': '_saved'}, SetOptions(merge : true));*/
                  await context.read<AuthenticationService>().signOut();
                  setState(() {
                    _currentUser = null;
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
            ]
          // ... to here
        ),
        body:_buildSuggestions()//Column(children:[_buildSuggestions(),_enableDismiss()])
    );                                      // ... to here.
  }

}