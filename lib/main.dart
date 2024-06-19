import 'package:driverapp/firebase_messaging.dart';
import 'package:driverapp/firebase_options.dart';
import 'package:driverapp/notification_handler.dart';
import 'package:driverapp/pushnotification/pushnotificationsystem.dart';
import 'package:driverapp/ui/destination.dart';
import 'package:driverapp/ui/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 FirebaseMessagingService.init();
  runApp( MyApp(
    
  ));
   
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

    final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();


//  @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

// Pushnotificationsystem pushnotificationsystem=Pushnotificationsystem();

// pushnotificationsystem.initializeCloudMessaging(context);
// pushnotificationsystem.generateAndGetToken();

//   }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
              scaffoldMessengerKey:scaffoldMessengerKey,

      home: 
         const Login()
    );
  }
}
