import 'package:Hw3/classes/modeWrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Hw3/classes/AuthenticationService.dart';
import 'package:Hw3/classes/bottomModal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';


class  logInScreen extends StatefulWidget {
  final Function updateFunc;
  final Function updateFsFunc;
  var savedWords;
  var wordsSuggestions;
  var savedList;
  logInScreen({ required this.updateFunc, required this.savedWords,
    required this.wordsSuggestions, required this.savedList, required this.updateFsFunc});

  @override
  _logInPageState createState() => _logInPageState();
}


class _logInPageState extends State<logInScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool alreadyPressed = false;

  @override
  void initState() {
    alreadyPressed = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.all(15),
        child : Column(
          children:[SizedBox( height: 20.0, ),
            Text("Welcome to startup Names Generator, please log in below",
            style: TextStyle(fontSize: 16,fontStyle: FontStyle.italic,fontWeight: FontWeight.w400),),
            SizedBox( height: 15.0, ),
            TextFormField(
              controller: email,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.only(
              topLeft: Radius.circular(2.0),
              topRight: Radius.circular(2.0),),
              borderSide: BorderSide(width:0.5,style: BorderStyle.solid),),
              focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(style: BorderStyle.solid),),
              contentPadding: EdgeInsets.zero,
              border: UnderlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid)),
              labelText:'Email',
              labelStyle: TextStyle(color: Colors.black,)),),
            SizedBox( height: 20.0,),
            TextFormField(
             controller: password,
             obscureText: true,
             cursorColor: Colors.black,
             decoration: const InputDecoration(
             enabledBorder: UnderlineInputBorder(
             borderRadius: BorderRadius.only(
             topLeft: Radius.circular(2.0),
             topRight: Radius.circular(2.0),),
             borderSide: BorderSide(width:0.5,style: BorderStyle.solid),),
             focusedBorder: UnderlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid),),
             contentPadding: EdgeInsets.zero,
             border: UnderlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid)),
             labelText:'Password',
             labelStyle: TextStyle(color: Colors.black,)),),
            SizedBox( height: 15.0,),
            ButtonTheme(
              child: SizedBox(
              width: 330,
              height: 30,
              child:ElevatedButton(
              onPressed: alreadyPressed ? null :() async {
                setState(() {
                  alreadyPressed = true;
                });
                User? _user = await context.read<AuthenticationService>().signIn(email: email.text.trim(), password: password.text.trim(),);
                if (_user != null) {
                  var userEmail = await Provider.of<currentUser>(context, listen: false);
                  userEmail.setUser(email.text);
                  var cloudWords =  await FirebaseFirestore.instance.collection('Users').doc(userEmail.userEmail).
                  get().then((querySnapshot) {return querySnapshot.data();});
                  setState (() {
                    if(cloudWords != null) {
                      widget.savedList = widget.savedList + cloudWords['favorites'];
                    }
                    widget.savedList = widget.savedList.toSet().toList();
                    for(int i = 0; i < widget.savedList.length; i++) {
                      String temp = widget.savedList[i].toString();
                      var tempList = temp.split('_');
                      String first = tempList[0];
                      String second = tempList[1];
                      WordPair tempWord = WordPair(first, second);
                      if(!widget.savedWords.contains(tempWord)) {
                        widget.savedWords.add(tempWord);
                      }
                    }
                    widget.updateFunc(widget.savedList,widget.savedWords,widget.wordsSuggestions);
                    if(widget.savedList.length > 0 ) {
                      widget.updateFsFunc(userEmail.userEmail);
                    }
                    Navigator.of(context).pop();
                  });
                }

                    else {
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('There was an error logging into the app'),));
                      });
                    }
                    setState(() {
                      alreadyPressed = false;
                    });
              },
              child: Text("Login"),
              /*style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,),*/
              style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),)),
                    backgroundColor:MaterialStateProperty.all(Colors.deepPurple)),

              ),),
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),),SizedBox( height: 15.0,),
                ButtonTheme(
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                child: SizedBox(
                width: 330,
                height: 30,
                child:ElevatedButton(
                style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),)),
                backgroundColor:MaterialStateProperty.all(Colors.blue)),
                child: Text("New user? Click here to sign up"),
                  onPressed: (){
                    viewBottomModal(context, password.text, email.text,widget.updateFsFunc );})))
                ],),), );}
}
