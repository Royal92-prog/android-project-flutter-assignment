import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Hw3/classes/modeWrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:Hw3/classes/AuthenticationService.dart';

void viewBottomModal(BuildContext context, String formPass, String email){
  final password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  showModalBottomSheet<void>(
   useRootNavigator: true,
   isScrollControlled: true,
   isDismissible: false,
   context: context,
   builder: (BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Padding(
          padding:EdgeInsets.all(15),
          child:
          Container(
          padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 40,),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text('Please confirm your password below:'),
              SizedBox(height: 20,),
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
              labelStyle: TextStyle(color: Colors.black,)),
              keyboardType: TextInputType.text,
              validator: (String? value) {
                return formPass != password.text ? 'Password must mutch' : null;},),
                SizedBox(height: 30.0,),
                SizedBox(
                      width: 100,
                      child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () async {
                        if (_formKey.currentState!.validate() != null && _formKey.currentState!.validate() == true) {
                          final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                            await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password.text);
                          //new line insert
                          await FirebaseFirestore.instance.collection('UsersURL').doc(email)
                            .set({'address' : 'none'}, SetOptions(merge: true));
                          User? _user = await context.read<AuthenticationService>().signIn(email: email, password: password.text);
                          if (_user != null) {
                            var userEmail = Provider.of<currentUser>(context, listen: false);
                            userEmail.setUser(email);
                          }
                          var nav = Navigator.of(context);
                          nav.pop();
                          nav.pop();
                         }},
                      textColor: Colors.white,
                      elevation: 2.0,
                      padding: EdgeInsets.all(8.0),
                      child: Text('Confirm', style: TextStyle(fontSize: 18.0,),),),),],)
          ,),)


        ),);},);
}
