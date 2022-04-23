# HW3 - dry Part
Answers:

1.The classs which is used to implement the controller pattern in this library is
SnappingSheetController.
It mainly allows to control the sheet in multiple ways.
First of all,using the controller one can change the position of the snapping sheet
using the methods of the class such as: setSnappingSheetPosition,snapToPosition.

In addition there exists a possibility of stoping user's current snapping by the method
stopCurrentSnapping.

The Class also allows to extract information from the sheet,using the methods:
currentPosition,currentSnappingPosition,currentlySnapping,isAttached.

We can conclude that the class provides the developer a very useful tools 
to update easily the layout on the screen upon changes on the snapping sheet state. 

2.snappingPositions is the parameter that controls the mentioned behaviour.
this parameter takes a list of SnappingPosition instances,which are all the positions
where the bottom sheet can snap to.

3. 
An advantage of inkWell over GestureDetector:
GestureDetector doesn't include ripple effect tap, which InkWell does - thus
for example,in case of demand to display a ripple animation when a button is tapped
we could use InkWell but not GestureDetector.

An advantage of GestureDetector over inkWell:
InkWell has a limited number of gestures to detect while GestureDetector class
is very broad and it covers more types of interactions the user has with the screen.

