import 'package:Hw3/classesManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Hw3/AuthenticationService.dart';
//import 'package:Hw3/Modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';


class  logInPage extends StatefulWidget {
  final Function updateFunc;
  final Function updateFsFunc;
  var savedWords;
  var wordsSuggestions;
  var savedList;
   logInPage({ required this.updateFunc, required this.savedWords,
    required this.wordsSuggestions, required this.savedList, required this.updateFsFunc});

  @override
  _logInPageState createState() => _logInPageState();
}


class _logInPageState extends State<logInPage> {
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
        padding: const EdgeInsets.all(30),
        child : Column(
          children:[SizedBox( height: 20.0, ),
            //define email & passwords fields
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

            SizedBox( height: 15.0,),
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
                      var userEmail = Provider.of<currentUser>(context, listen: false);
                      userEmail.setUser(email.text);
                      var cloudWords =  await FirebaseFirestore.instance.collection('Users').doc(userEmail.userEmail).
                      get().then((querySnapshot) {return querySnapshot.data();});
                      setState (() {
                          if(cloudWords != null) {
                            widget.savedList = widget.savedList + cloudWords['favorites'];
                          }
                          print(widget.savedList);
                          widget.savedList = widget.savedList.toSet().toList();
                          for(int i = 0; i < widget.savedList.length; i++){
                            String temp = widget.savedList[i].toString();
                            var tempList = temp.split('_');
                            String first = tempList[0];
                            String second = tempList[1];
                            WordPair tempWord = WordPair(first, second);
                            if(!widget.savedWords.contains(tempWord)){
                              widget.savedWords.add(tempWord);
                            }
                          }
                          if(widget.savedList.length > 0 ){
                            widget.updateFsFunc(userEmail.userEmail);
                          }

                          widget.updateFunc(widget.savedList,widget.savedWords,widget.wordsSuggestions);
                          // Navigator.pop(context);

                      });
                      //Navigator.pop(context, email.text.trim());
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
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                    onPrimary: Colors.white,
                  ),),),
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            ),SizedBox( height: 15.0,),
            ButtonTheme(
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              child: SizedBox(
                width: 330,
                height: 30,
                child:ElevatedButton(
                child: Text("New user? Click here to sign up"),
                  onPressed: () async {
                  bool res = true; //await func(context,password.text);
                  final confirmPass = TextEditingController();
                  final _formKey = GlobalKey<FormState>();
                  showModalBottomSheet<void>(
                    useRootNavigator: true,
                    isScrollControlled: true,
                    isDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child:  Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 40,),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height/3,
                            child: ListView(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    TextFormField(
                                      controller: confirmPass,
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
                                        return password.text != confirmPass.text ? 'Password must mutch' : null;},),
                                    SizedBox(height: 30.0,),
                                    SizedBox(
                                      width: 100,
                                      child: RaisedButton(
                                        color: Colors.blue,
                                        onPressed: () async {
                                          print(password.text);
                                          print(confirmPass.text);
                                          if (_formKey.currentState!.validate() != null && _formKey.currentState!.validate() == true) {
                                            print('ynon Shteger');
                                            final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                                            await _firebaseAuth.createUserWithEmailAndPassword(
                                                email: email.text, password: password.text);
                                            User? _user = await context.read<AuthenticationService>()
                                                .signIn(email: email.text, password: password.text);
                                            if (_user != null) {
                                              var userEmail = Provider.of<currentUser>(
                                                  context, listen: false);
                                              userEmail.setUser(email.text);
                                            }
                                            var nav = Navigator.of(context);
                                            nav.pop();
                                            nav.pop();
                                            print("sabono11");}},
                                        textColor: Colors.white,
                                        elevation: 2.0,
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Confirm',
                                          style: TextStyle(fontSize: 18.0,),),),)
                                    ,],),],),),),);},);

                  //if(res == true) {

                    //print("Line 161");
                   // Navigator.of(context).pop();
                //  }
                 //
                  })))
                  /*() => async{
                    //func(context,password.text);
                    final FirebaseAuth _firebaseAuth =  FirebaseAuth.instance;

                    //try {
                    print("line 156");

                    showModalBottomSheet<void>(
                      isScrollControlled: true,
                       context: context,
                      builder: Modal(formPass: 'formPass')
                    )
                     // Navigator.pop(context, email.text);
                    print("line 156");
                    //}
                    /*on FirebaseAuthException catch (e) {
                      return null;
                    }*/

                  },*/

//  child: Text("New user? Click here to sign up"),)
          ],),), );}


}
