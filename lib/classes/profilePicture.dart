import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';


class getPicture extends StatelessWidget {
  final String email;
  getPicture(this.email);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('UsersURL').doc(email).get(),
      builder:(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot)  {
        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> currentPicture = snapshot.data!.data() as Map<String, dynamic>;
          if(currentPicture == null) {
            return SizedBox(width: 15);
          }

    return CircleAvatar(
      radius: 50,
      backgroundImage: NetworkImage(currentPicture['address']),
    );}

    return Center(child: CircularProgressIndicator());
    });}
}


class pictureHandler extends StatefulWidget{
  pictureHandler({Key? key,required this.email}) : super(key: key);
  String email;

  @override
  State<pictureHandler> createState() => _pictureState();
}


class _pictureState extends State<pictureHandler> {

  Widget changeAvatar(){
    return ElevatedButton(
      child: Text('Change avatar'),
      onPressed: () async {
        final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg'],);
        if(result == null){
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')));
        }

        else {
          final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
          final path = result.files.single.path;
          final fileName = result.files.single.name;
          File file = File(path!);
          try{
            await storage.ref('files/$fileName').putFile(file);
          }
          on firebase_core.FirebaseException catch (e) {
                print(e);
          }
          String returnURL = await storage.ref('files/$fileName').child(path).getDownloadURL();
          Map<String, dynamic> data = {"favorites": returnURL};
          await FirebaseFirestore.instance.collection('UsersURL').doc(widget.email)
          .set(data,SetOptions(merge : false));
           }});
   }

  @override
  Widget build(BuildContext context) {
    return Row(children: [getPicture(widget.email),Column(children: [Text(widget.email),changeAvatar()],)],);
  }
}




/*  Future<Widget> getProfilePicture() async{
    var currentPicture =  await FirebaseFirestore.instance.collection('UsersURL').doc(widget.email).
    get().then((querySnapshot) {return querySnapshot.data();});
    if(currentPicture == null) {
      return SizedBox(width: 15);
    }

    return CircleAvatar(
      radius: 50,
      backgroundImage: NetworkImage(currentPicture['address']),
    );
  }*/





