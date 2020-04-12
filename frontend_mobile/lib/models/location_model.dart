import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class LocationModel extends ChangeNotifier {
  double _latitude;
  double _longitude;

  double get latitude => _latitude;
  double get longitude => _longitude;

  LatLng get location => LatLng(_latitude, _longitude);

  set locationObj(LatLng newLoc) {
    _latitude = newLoc.latitude;
    _longitude = newLoc.longitude;
    notifyListeners();
  }

  set locationList(List<double> newLoc) {
    _latitude = newLoc[0];
    _longitude = newLoc[1];
    notifyListeners();
  }
}
