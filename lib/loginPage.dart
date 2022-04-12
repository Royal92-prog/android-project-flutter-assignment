import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Hw3/AuthenticationService.dart';


class logInPage extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:MyCustomForm(),);
  }
}


class MyCustomForm extends StatefulWidget {


  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}


class _MyCustomFormState extends State<MyCustomForm> {
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
                width: 270,
                height: 30,
                child:ElevatedButton(
                  onPressed: alreadyPressed ? null :() async {
                    setState(() {
                      alreadyPressed = true;
                    });
                    User? _user = await context.read<AuthenticationService>().signIn(email: email.text.trim(), password: password.text.trim(),);
                    if (_user != null) {
                      Navigator.pop(context, email.text.trim());
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
            ),],),), );}


}