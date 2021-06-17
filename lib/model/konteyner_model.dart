import 'package:google_maps_flutter/google_maps_flutter.dart';

class KonteynerModel{
  String sensorID;
  String containerID;
  String time;
  int rate;
  LatLng latLng;
  String temp;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data ={'latitude':latLng.latitude,'longitude':latLng.longitude};
    return data;
  }

  KonteynerModel({this.sensorID, this.containerID, this.time, this.rate, this.latLng, this.temp});
}