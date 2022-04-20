import 'package:flutter/material.dart';

bool func(BuildContext context,String formPass){
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
                        onPressed: () {
                          if (_formKey.currentState!.validate() != null && _formKey.currentState!.validate() == true) {
                            print('ynon Shteger');
                            var nav = Navigator.of(context);
                            nav.pop();
                            //nav.pop();
                            print("sabono11");}},
                        textColor: Colors.white,
                        elevation: 2.0,
                        padding: EdgeInsets.all(8.0),
                        child: Text('Confirm',
                          style: TextStyle(fontSize: 18.0,),),),)
                    ,],),],),),),);},);
 return true;
}

















/*
Navigator.of(context).push(
MaterialPageRoute<void>(
builder: (context) {
return Scaffold(
appBar: AppBar(
title: const Text('Saved Suggestions'),
),
body: p?userModeScreen(updateFsFunc:statusUpdate,email: this._currentUser.toString(),):userModeScreen(
updateFsFunc:statusUpdate,email: this._currentUser.toString(),)
);},),);


class Modal extends StatelessWidget{
  final String formPass;
  const Modal({Key? key,required this.formPass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final password = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child:SingleChildScrollView(
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
                          onPressed: () {
                            if (_formKey.currentState!.validate() != null && _formKey.currentState!.validate() == true) {
                              //var nav = Navigator.of(context);
                              // nav.pop();
                              //nav.pop();
                              print("sabono11");}},
                          textColor: Colors.white,
                          elevation: 2.0,
                          padding: EdgeInsets.all(8.0),
                          child: Text('Confirm',
                            style: TextStyle(fontSize: 18.0,),),),)
                      ,],),],),),),),);//}

  }




}*/


