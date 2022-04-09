import 'package:flutter/material.dart';
import 'package:hello_me2/AuthenticationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
/*
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Retrieve Text Input',
      home: MyCustomForm(),
    );
  }
}
*/
// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final email = TextEditingController();
  final password = TextEditingController();
  bool alreadyPressed = false;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children:[
          TextFormField(
            controller: this.email,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: UnderlineInputBorder(),
              // alignLabelWithHint: true,
              labelText:'email',

              //center(child:Text('email'),

            ),),
          TextFormField(
            controller: this.password,
            //textAlign: TextAlign.center,
            obscureText: true,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'password'
              ,contentPadding: EdgeInsets.zero,
            ),),
          /*RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },*/

          ButtonTheme(
            minWidth: 290.0,
            height: 20.0,
            buttonColor: Colors.deepPurple,
            child: RaisedButton(
              onPressed:this.alreadyPressed ? null: () {      // NEW lines from here...
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(pair);
                  } else {
                    _saved.add(pair);
                  }
                });
              },
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              child: Text("Login"),
            ),
          )],),);}

  pressedCallBack(){
    this.alreadyPressed = true;
    FirebaseAuth _firebaseAuth ;
    _firebaseAuth .instance {
      _auth.authStateChanges().listen(_onAuthStateChanged);
      _user = _auth.currentUser;
      _onAuthStateChanged(_user);
    }
    final x = new AuthenticationService();
    x.signIn(email: this.email.toString(), password: this.password.toString());

  }
}

