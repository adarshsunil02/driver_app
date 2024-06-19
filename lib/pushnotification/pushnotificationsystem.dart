import 'package:driverapp/pushnotification/dialoguebox.dart';
import 'package:driverapp/user_ride_request_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Pushnotificationsystem {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  Future initializeCloudMessaging(BuildContext context) async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        readUserRideInfo(remoteMessage.data["rideRequestId"], context);
      }
    });
// Forground

    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      readUserRideInfo(remoteMessage!.data["rideRequestID"], context);
    });
//background
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage? remoteMessage) {
        readUserRideInfo(remoteMessage!.data["rideRequestID"], context);
      },
    );
  }

  readUserRideInfo(String userRideRequestId, BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .child(userRideRequestId)
        .child("driverid")
        .onValue
        .listen(
      (event) {
        if (event.snapshot.value == "wating") {
          FirebaseDatabase.instance
              .ref()
              .child("All Ride Requests")
              .child(userRideRequestId)
              .once()
              .then(
            (snapData) {
              if (snapData.snapshot.value != null) {
                double orginLat = double.parse(
                    (snapData.snapshot.value! as Map)['orgin']['latitude']);
                double orginLng = double.parse(
                    (snapData.snapshot.value! as Map)['orgin']['longitude']);
                String orginAddress =
                    (snapData.snapshot.value! as Map)['orginAddress'];

                double destinationnLat = double.parse((snapData.snapshot.value!
                    as Map)['destination']['latitude']);
                double destinationLng = double.parse((snapData.snapshot.value!
                    as Map)['destination']['longitude']);
                String destinationAddress =
                    (snapData.snapshot.value! as Map)['destinationAddress'];
                String username = (snapData.snapshot.value! as Map)['username'];
                String userPhone =
                    (snapData.snapshot.value! as Map)['userPhone'];
                
                String? rideRequestId=snapData.snapshot.key;

                UserRideRequestInfo userRideRequestDetails=UserRideRequestInfo();
                userRideRequestDetails.orginLatLan=LatLng(orginLat, orginLng);
                userRideRequestDetails.orginAddress=orginAddress;
                userRideRequestDetails.destinationLatLng=LatLng(destinationnLat, destinationLng);
                userRideRequestDetails.destinationAddress=destinationAddress;
                userRideRequestDetails.username=username;
                userRideRequestDetails.userPhone=userPhone;

                userRideRequestDetails.rideRequestId=rideRequestId;


                showDialog(
                  context: context,
                   builder: (BuildContext context) => NotificationDialogueBox(
                    userRideRequestDetails
                   ),);
              }
              else{
                Fluttertoast.showToast(msg:"this Ride Request Id  do not exits");
              }
            },
          );
        }else{
          Fluttertoast.showToast(msg:"this Ride Request has been cancelled");
          Navigator.pop(context);
        }
      },
    );

  }

  Future generateAndGetToken()async{
    String? registrationToken = await firebaseMessaging.getToken();
    print("FCM registration token:${registrationToken}");

    FirebaseDatabase.instance.ref()
    .child("drivers")
    .child(_firebaseAuth.currentUser!.uid)
    .child('token')
    .set(registrationToken);

    firebaseMessaging.subscribeToTopic('allDrivers');
    firebaseMessaging.subscribeToTopic('allUsers');
  }
}
