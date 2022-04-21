import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:Hw3/screens/logInScreen.dart';
import 'package:Hw3/screens/favoritesScreen.dart';
import 'package:provider/provider.dart';

import '../classes/AuthenticationService.dart';
import '../classes/modeWrapper.dart';

class homeScreen extends StatefulWidget{
  String? email;
  final Function updateFunc;
  final Function updateFsFunc;
  var savedWords;
  var wordsSuggestions;
  var savedList;
  homeScreen({required this.updateFsFunc, required this.updateFunc, required this.email, required this.savedWords,
    required this.wordsSuggestions, required this.savedList} ){
    print("user is:: Line 16 ::   ");
    print(this.email);}

  @override
  State<homeScreen> createState() => _homeScreenState();
}


class _homeScreenState extends State<homeScreen> {


  Widget _buildSuggestions() {
    return ListView.builder(
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider();
        }
        final index = i ~/ 2;
        if (index >= widget.wordsSuggestions.length) {
          widget.wordsSuggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(widget.wordsSuggestions[index]);//
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = widget.savedWords.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: Icon(
        alreadySaved ? Icons.star : Icons.star_border,
        color: alreadySaved ? Colors.deepPurple : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ),
      onTap: () async{
        setState(() {
          if (alreadySaved) {
            widget.savedWords.remove(pair);
            widget.savedList.remove(pair.asSnakeCase);
          }
          else {
            widget.savedWords.add(pair);
            widget.savedList.add(pair.asSnakeCase);
          }});
        widget.updateFsFunc(widget.email);
      },);}

  void _pushFavoritesSc() async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Saved Suggestions'),
              ),
              body: savedWords(words : widget.savedWords, wordsList: widget.savedList,
              wordsSetUpdateFunc:widget.updateFunc, updateFsFunc: widget.updateFsFunc,
              currentUser: widget.email),
          );},),);
  }

  void _pushLogin() async{
   await Navigator.push(context,
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Login'),
              centerTitle: true,
            ),
            body: logInScreen(updateFunc: widget.updateFunc, savedWords: widget.savedWords,
            wordsSuggestions: widget.wordsSuggestions, savedList: widget.savedList,
            updateFsFunc: widget.updateFsFunc,),);
        },),);

    //Navigator.popAndPushNamed(context,'/modesWrapper');
    print("line112");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
          title: const Text('Startup Name Generator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _pushFavoritesSc,
              tooltip: 'Saved Suggestions',
            ),
            widget.email != null ? IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed:() async {
                setState(() {
                  widget.email = null;
                  widget.savedList = [];
                  widget.savedWords = <WordPair>{};
                  widget.updateFunc(widget.savedList, widget.savedWords, null);
                });
                await context.read<AuthenticationService>().signOut();
                var userEmail = Provider.of<currentUser>(context, listen: false);
                userEmail.setUser(null);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Successfully logged out'),));
                //widget.updateFunc(widget.savedList,widget.savedWords,widget.wordsSuggestions,widget.email);
                //Navigator.pop(context);
              },
              tooltip: 'login',
            ) : IconButton(
              icon: const Icon(Icons.login),
              onPressed: _pushLogin,
              tooltip: 'login',),
          ]),
      body:_buildSuggestions(),
    );                                     // ... to here.
  }
}