import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class getPicture extends StatelessWidget {
  final String email;
  getPicture(this.email);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('UsersURL').doc(email).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot)  {
        if (snapshot.connectionState == ConnectionState.active){
          if(snapshot.data!.data() == null){
            return SizedBox(width: 70);
          }
        Map<String, dynamic> currentPicture = snapshot.data!.data() as Map<String, dynamic>;
    return CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage(currentPicture['address']),
    );}
    return Center(child: CircularProgressIndicator());
    });}
}

class pictureHandler extends StatefulWidget{
  String email;
  final controller;
  pictureHandler({Key? key, required this.email, required this.controller}) : super(key: key);

  @override
  State<pictureHandler> createState() => _pictureState();
}

class _pictureState extends State<pictureHandler> {

  Widget changeAvatar(){
    return SizedBox(
    width: 140,
    height: 30,
    child: ElevatedButton(
      child: Text('Change avatar',),
      onPressed: () async {
        final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg'],);

        if(result == null){
          widget.controller.snapToPosition(SnappingPosition.factor(positionFactor:0.1,grabbingContentOffset:0));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(behavior:SnackBarBehavior.fixed,
          content: Text('No image selected')));//margin:EdgeInsets.only(top: 90),
        }

        else {
         final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
         final path = result.files.single.path;
         final fileName = result.files.single.name;
         File file = File(path!);
         try {
          await storage.ref('users/${widget.email}/$fileName').putFile(file);
         }
         on firebase_core.FirebaseException catch (e) {
          print(e);
         }

         var doc =  await FirebaseFirestore.instance.collection('UsersURL').doc(widget.email).
         get().then((querySnapshot) {return querySnapshot.data();});

         if (doc != null){
          await storage.refFromURL(doc['address']).delete();
         }
         String returnURL = await storage.ref('users/${widget.email}/$fileName').getDownloadURL();//'files/$fileName'
         Map<String, dynamic> data = {"address": returnURL};
         await FirebaseFirestore.instance.collection('UsersURL').doc(widget.email)
         .set(data,SetOptions(merge : false));
         }}));
   }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 15) ,child: Row(children: [SizedBox(width: 30),
      getPicture(widget.email),SizedBox(width: 20), Column(mainAxisAlignment:MainAxisAlignment.
      spaceBetween,children: [Text(widget.email,style:
      TextStyle(fontSize:20,color: Colors.black,fontWeight: FontWeight.w300)),
      SizedBox(height: 10),changeAvatar()],)],));
  }
}

