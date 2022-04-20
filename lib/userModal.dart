import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:Hw3/loginPage.dart';
import 'package:Hw3/AuthenticationService.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
/*
class userModal {
  String emailAddress;
  userModal(this.emailAddress);

  //@override
  //State<userModal> createState() => _modalStates();
}

//class _modalStates extends State <userModal> {

  Widget build(BuildContext context) {
    //var x = ScrollController(1,keepScrollOffset: true,)
    return column(
      initialChildSize: 0.6,
      minChildSize: 0.6,
      maxChildSize: 1.0,
      //context: context,
      builder:(context,ScrollController) => Container(
        height: 15,
        child:Column(children: [Text("AB"),Text("ABC"),Text("ABCD")],)
      ),
    );
  }
}

*/
