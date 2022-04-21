import 'package:Hw3/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:Hw3/classes/pictureService.dart';

class userModeScreen extends StatefulWidget {
   userModeScreen({required this.updateFsFunc, required this.email, required this.savedWords,
   required this.savedList, required this.wordsSuggestions, required this.updateFunc});
   final Function updateFunc;
   final Function updateFsFunc;
   var savedWords;
   var wordsSuggestions;
   var savedList;
   String? email;

  @override
  State<userModeScreen> createState() => userModeStates();
}

class userModeStates extends State<userModeScreen> {
  final snappingSheetController = SnappingSheetController();

  @override
  Widget build(BuildContext context) {
    return Container(child:SnappingSheet(
        controller: snappingSheetController,
        initialSnappingPosition:SnappingPosition.factor(positionFactor:0.1,grabbingContentOffset:0),
      snappingPositions : const [SnappingPosition.factor(positionFactor:0.1,grabbingContentOffset:0),
        SnappingPosition.factor(positionFactor:0.35,grabbingContentOffset:0),
        SnappingPosition.factor(positionFactor:0.55,grabbingContentOffset:0),
        SnappingPosition.factor(positionFactor:0.70,grabbingContentOffset:0),
        SnappingPosition.factor(positionFactor:0.85,grabbingContentOffset:-1.25)
      ],
        child: homeScreen(updateFsFunc:widget.updateFsFunc, updateFunc: widget.updateFunc,
        email: widget.email, savedWords:widget.savedWords , wordsSuggestions: widget.wordsSuggestions,savedList: widget.savedList, ),
      grabbingHeight: 150,

      grabbing: Scaffold(body: Column(children: [GestureDetector(
          child: Container(height: 50, color: Colors.grey, child:
          Padding(padding: EdgeInsets.only(top:16,bottom: 16),
          child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Align(alignment: Alignment.topLeft, child:
          Text('   Welcome back, '+ widget.email.toString(), style:
          TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400)),),
          Align(alignment: Alignment.topRight,child: Row(mainAxisAlignment: MainAxisAlignment.end,
          children: [Icon(Icons.keyboard_arrow_up, color: Colors.black,),Text(' '),]),)],)),),
          onTap: () {
          double position = snappingSheetController.currentPosition;

          if (position == 73.74545454545455 ) {
              snappingSheetController.setSnappingSheetPosition(-25);
          }

          else {
            snappingSheetController.snapToPosition(SnappingPosition.factor(positionFactor:0.1,grabbingContentOffset:0));
          }
        },),
          pictureHandler(email: widget.email.toString(), controller: snappingSheetController,), ],)),
      sheetBelow:SnappingSheetContent(child:Container(color:Colors.white)),
    ),);

  }
}
