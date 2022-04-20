import 'package:Hw3/userModal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:Hw3/loginPage.dart';
import 'package:Hw3/AuthenticationService.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:Hw3/login2.dart';

class savedWords extends StatefulWidget {

  var words;
  var wordsList;
  final Function wordsSetUpdateFunc;
  final Function updateFsFunc;
  String? currentUser;
  savedWords({Key? key, required this.words, required this.wordsList,
  required this.wordsSetUpdateFunc, required this.updateFsFunc}) : super(key: key);

  @override
  State<savedWords> createState() => _savedWordsState();
}

class _savedWordsState extends State<savedWords> {

  @override
  Widget build(BuildContext context) {
    final allKept = widget.words.toList();
    return Container(
      child: allKept.length > 0 ? ListView.builder(
        itemCount: allKept.length,
        itemBuilder: (BuildContext context, int index) {
        return Dismissible(confirmDismiss: (DismissDirection horizontal) {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Delete Suggestion'),
                content: Text('are you sure you want to delete ${allKept[index]} from your saved suggestions?'),
                actions: [TextButton(onPressed: () {
                  Navigator.of(context).pop(true);
                  setState(() {
                  widget.words.remove(allKept[index]);
                  widget.wordsList.remove(allKept[index].asSnakeCase);});
                  widget.wordsSetUpdateFunc(widget.wordsList,widget.words);
                  widget.updateFsFunc();},
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.deepPurple,),
                child: const Text('Yes'),),
                TextButton(onPressed: () {
                  Navigator.of(context).pop(false);},
                child: const Text('no'),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.deepPurple,),)],);});},
                background: Container(
                  color: Colors.deepPurple,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:[
                      Icon(
                        Icons.delete,
                        color: Colors.white,),
                      Text('Delete Suggestion',
                      style: TextStyle(color: Colors.white),),],),),),
                    child: ListTile(
                      title: Text(
                        allKept[index].asPascalCase,
                        style: const TextStyle(fontSize: 18),),),//divided[index],
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
                            color: Colors.white,),
                          Text('Delete Suggestion',
                          style: TextStyle(color: Colors.white),),],),),),);},) : Center(child: Text('No Items')),);

  }
}