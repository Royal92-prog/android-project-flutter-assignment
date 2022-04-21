import 'package:Hw3/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:Hw3/classes/pictureService.dart';

class userModeScreen extends StatefulWidget {
   userModeScreen({required this.updateFsFunc, required this.email, required this.savedWords,
   required this.savedList, required this.wordsSuggestions, required this.updateFunc}){
     print("user is:: Line 16 ::   ");
     print(this.email);
     print('words:: ');
    print(this.savedWords);
   }
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
    print('Line 33');
      print(widget.savedWords);
    return Container(child:SnappingSheet(
        controller: snappingSheetController,
        initialSnappingPosition:SnappingPosition.factor(positionFactor:0.1,grabbingContentOffset:0),
      snappingPositions : const [SnappingPosition.factor(positionFactor:0.1,grabbingContentOffset:0),
        SnappingPosition.factor(positionFactor:0.35,grabbingContentOffset:0),
        SnappingPosition.factor(positionFactor:0.55,grabbingContentOffset:0),
        SnappingPosition.factor(positionFactor:0.70,grabbingContentOffset:0),
        SnappingPosition.factor(positionFactor:0.85,grabbingContentOffset:-1.25)
      ],
      //SnappingPosition.pixels(positionPixels: 100) : SnappingPosition.pixels(positionPixels: 0),
      //snappingPositions: [SnappingPosition.pixels(positionPixels: 200),SnappingPosition.pixels(positionPixels: 200)],
        /*child:Container(
        color: Colors.green,
        //padding: const EdgeInsets.all(8),
      // Change button text when light changes state.
      //child: Text(_lightIsOn ? 'TURN LIGHT OFF' : 'TURN LIGHT ON'),
    )*/
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
          print(snappingSheetController.currentPosition);
          double position = snappingSheetController.currentPosition;
          /*if(position == -25){
            snappingSheetController.snapToPosition(SnappingPosition.factor(positionFactor:0.1,grabbingContentOffset:0));
          }*/
          if (position == 73.74545454545455 ) {//position <= 72.4909 &&
            //snappingSheetController.snapToPosition(SnappingPosition.factor(positionFactor:0.099));//095
            //print(position);
              snappingSheetController.setSnappingSheetPosition(-25);
          }
          //snappingSheetController.currentSnappingPosition
          else {
            print('kawasaki');
            snappingSheetController.snapToPosition(SnappingPosition.factor(positionFactor:0.1,grabbingContentOffset:0));
           // snappingSheetController.snapToPosition()//snapToPosition(SnappingPosition.pixels(positionPixels:0.0000000000000006,grabbingContentOffset: 0.0000000024));
          }

        },),
          pictureHandler(email: widget.email.toString(), controller: snappingSheetController,), ],)),
      sheetBelow:SnappingSheetContent(child:Container(color:Colors.white)),
    ),);

  }
}


/*Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Align(alignment:Alignment.topLeft,
              child:Text('   Welcome back, '+ widget.email.toString(),style: TextStyle(fontSize:18,color: Colors.black)),),
          Align(alignment:Alignment.topRight,child:Row(mainAxisAlignment:MainAxisAlignment.end,
            children:[Icon( Icons.keyboard_arrow_up, color: Colors.black,),Text(' '),]),)],)*/