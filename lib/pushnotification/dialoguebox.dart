import 'package:driverapp/user_ride_request_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationDialogueBox extends StatefulWidget {
  
UserRideRequestInfo? userRideRequestDetails;

NotificationDialogueBox(this.userRideRequestDetails);


  @override
  State<NotificationDialogueBox> createState() => _NotificationDialogueBoxState();
}

class _NotificationDialogueBoxState extends State<NotificationDialogueBox> {
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {

    bool darktheme=MediaQuery.of(context).platformBrightness==Brightness.dark;

    return  Dialog(
      shape: RoundedRectangleBorder(
        borderRadius:BorderRadius.circular(24)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          margin: EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: darktheme? Colors.black : Colors.white
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("New ride request"),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("cancel")),

              ElevatedButton(onPressed: (){
                rideRequest(context);
              }, child: Text("Accepet"))
            ],


          ),
        ),
    );
  }
  rideRequest(BuildContext context){
    FirebaseDatabase.instance.ref()
    .child('drivers')
    .child(_firebaseAuth.currentUser!.uid)
    .child('userRideStatus')
    .once()
    .then((snap) {
      if(snap.snapshot.value=="idle"){
        FirebaseDatabase.instance.ref().child("drivers").child(_firebaseAuth.currentUser!.uid).child("newRideStatus").set("accepted");
      //  Navigator.push(context, MaterialPageRoute(builder: (context) => NewTripScreen(mounted),));
      }else{
        Fluttertoast.showToast(msg:"this ride request do not exits");
      }
    },);
  }
}