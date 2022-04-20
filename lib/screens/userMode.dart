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
import 'package:Hw3/screens/savedWords.dart';
import 'package:snapping_sheet/snapping_sheet.dart';


class userModeScreen extends StatefulWidget {
   userModeScreen({required this.updateFsFunc, required this.email, required this.savedWords}){
     print("user is:: Line 16 ::   ");
     print(this.email);
     print('words:: ');
    print(this.savedWords);
   }
  final Function updateFsFunc;
  String email;
  var savedWords;

  @override
  State<userModeScreen> createState() => userModeStates();
}

class userModeStates extends State<userModeScreen> {
  Color _color = Colors.white;

  bool current = false;
  final snappingSheetController = SnappingSheetController();
  double x = 75;
  @override
  Widget build(BuildContext context) {

    return Container(child:SnappingSheet(
        controller: snappingSheetController,
        initialSnappingPosition:SnappingPosition.factor(positionFactor:0.2,grabbingContentOffset:GrabbingContentOffset.bottom),
      //SnappingPosition.pixels(positionPixels: 100) : SnappingPosition.pixels(positionPixels: 0),
      //snappingPositions: [SnappingPosition.pixels(positionPixels: 200),SnappingPosition.pixels(positionPixels: 200)],
        child:Container(
        color: Colors.green,
        //padding: const EdgeInsets.all(8),
      // Change button text when light changes state.
      //child: Text(_lightIsOn ? 'TURN LIGHT OFF' : 'TURN LIGHT ON'),
    ),
      grabbingHeight: 195,

      grabbing:GestureDetector(

        onTap: () {
          print(snappingSheetController.currentPosition);
          double position = snappingSheetController.currentPosition;
          if (position <= 131.499 && position > 21.696) {
            snappingSheetController.snapToPosition(SnappingPosition.factor(positionFactor:0.033));
            print(position);
          }
          //snappingSheetController.currentSnappingPosition
          else {
            snappingSheetController.snapToPosition(SnappingPosition.factor(positionFactor:0.2));
          }

        },
        child : Column(children:[Container(height:45,width:400,color: Colors.grey,child: Row(
          children:[Row(mainAxisAlignment: MainAxisAlignment.start,children: [//SizedBox(width: 10,),
            Text('Welcome back, '+ widget.email,style: TextStyle(fontSize:14,color: Colors.black)),],), Padding(padding: EdgeInsets.only(left:40),
            child: Icon( Icons.keyboard_arrow_up, color: Colors.black,),)],),),
          Container(height:150,width:400,color: Colors.white,child: Row(
          children:[Row(mainAxisAlignment: MainAxisAlignment.start,children: [//SizedBox(width: 10,),
            Text('Welcome back, '+ widget.email,style: TextStyle(fontSize:14,color: Colors.black),),],), Padding(padding: EdgeInsets.only(left:40),
            child: Icon( Icons.keyboard_arrow_up, color: Colors.black,),)],),),]),),




      sheetBelow:SnappingSheetContent(child:Container(color:Colors.white)),
    ),);

  }
}
