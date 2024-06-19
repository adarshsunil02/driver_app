import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRideRequestInfo {
  LatLng? orginLatLan;
  LatLng? destinationLatLng;
  String? orginAddress;
  String? destinationAddress;
  String? rideRequestId;
  String? username;
  String? userPhone;

  UserRideRequestInfo(
      {this.orginLatLan,
      this.destinationLatLng,
      this.orginAddress,
      this.destinationAddress,
      this.rideRequestId,
      this.username,
      this.userPhone});
}
