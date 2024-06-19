import 'dart:async';
import 'package:driverapp/directions.dart';
import 'package:driverapp/firebaseauth.dart';
import 'package:driverapp/mapkey.dart';
import 'package:driverapp/notification_handler.dart';
import 'package:driverapp/request_assistant.dart';
import 'package:driverapp/ui/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';

import 'package:location/location.dart' as loc;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Destination extends StatefulWidget {
  const Destination({super.key});

  @override
  State<Destination> createState() => MapSampleState();
}

class MapSampleState extends State<Destination> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController? newGoogleMapController;
  LatLng? picklocation;
  loc.Location location = loc.Location();
  String? _address;
  String? _fromAddress;
  String? _toAddress;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 220;
  double watingResponcefromDriverContainerHeight = 0;
  double assignedDriverInfoHeight = 0;
  Position? driverCurrentPositon;
  var geolocation = Geolocator();

  LocationPermission? _locationPermission;
  double bottompaddingOfMap = 0;

  List<LatLng> pLineCoordinateList = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  bool activeNearbyDriverKeyLoaded = true;

  BitmapDescriptor? activeNearbyIcon;

String statusText="offline";
bool driverIsActive=false;
  // final _fromController = TextEditingController();
  // final _toController = TextEditingController();

  locatateDriverPosition() async {
    Position cPostion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      driverCurrentPositon = cPostion;
    });

    LatLng latLngPostion =
        LatLng(driverCurrentPositon!.latitude, driverCurrentPositon!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPostion, zoom: 15);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress = await searchAddressForGeogragraphCordinates(
        driverCurrentPositon!, context);
    print("this is our address = " + humanReadableAddress);
    setState(() {
      _fromAddress = humanReadableAddress;
    });
  }

  getAddressFromLatLng(LatLng latLng) async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: latLng.latitude,
          longitude: latLng.longitude,
          googleMapApiKey: mapKey);
      return data.address;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }
// readCurrentDriverInformation() async{
//   currentUser=_firebaseAuth,
//   FirebaseDatabase
// }

  @override
  void initState() {

    super.initState();
 _address = "Current Location";
    checkIfLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: NotificationHandler.scaffoldMessengerKey, 
            appBar: AppBar(
              
          centerTitle: true,
          title: const Text('Destination'),
          actions: [
            IconButton(
                onPressed: () async {
                  await AuthService.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                    (route) => true,
                  );
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: SafeArea(
          child: Stack(children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _kGooglePlex,
              polylines: polylineSet,
              markers: markerSet,
              circles: circleSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;
                setState(() {});

                locatateDriverPosition();
              },
              onCameraMove: (CameraPosition? position) {
                if (picklocation != position!.target) {
                  setState(() {
                    picklocation = position.target;
                  });
                }
              },
              onCameraIdle: () async {
                String toAddress = await getAddressFromLatLng(picklocation!);
                setState(() {
                  _toAddress = toAddress;
                });           
                drawPolyline();
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: Image.asset(
                  "assets/placeholder.png",
                  height: 45,
                  width: 45,
                ),
              ),
            ),
           
          ]),
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: () {
              drawPolyline();
            },
            child: const Text(
              "Request for Ride",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ));
  }

  drawPolyline() async {
    print("Drawing polyline...");
    List<LatLng> polylineCoordinates = [];
    polylineCoordinates.add(
        LatLng(driverCurrentPositon!.latitude, driverCurrentPositon!.longitude));
    polylineCoordinates.add(picklocation!);

    // just checking
    print("Polyline coordinates: $polylineCoordinates");

    Polyline polyline = Polyline(
      polylineId: const PolylineId("polyline"),
      color: Colors.blue,
      width: 5,
      points: polylineCoordinates,
    );

    // just checking
    print("Polyline created: $polyline");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        polylineSet.add(polyline);
      });

      // just checking
      print("Polyline added to set: $polylineSet");
    });
  }

  static Future<String> searchAddressForGeogragraphCordinates(
      Position position, context) async {
    String apiurl ="https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    String humanReadableAddress = "";

    var requsestResponse = await RequestAssistant.reciveRequest(apiurl);

    if (requsestResponse != "Error occurd. Failed .No Response") {
      humanReadableAddress =
          requsestResponse["results"][0]["formatted_address"];

      Directions userPickupAddress = Directions();
      userPickupAddress.locationLatitude = position.latitude;
      userPickupAddress.locationLongitude = position.longitude;
      userPickupAddress.locationName = humanReadableAddress;

// Provider.of<Appinfo>(context,listen:false).updatePickUpLocationAddress(userPickupAddress);
    }
    return humanReadableAddress;
  }
}
