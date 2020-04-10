import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocation/geolocation.dart';

void main() => runApp(AppContainer());

class AppContainer extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primaryColor: Colors.white),
        darkTheme: ThemeData.dark(),
        home: App());
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  StreamSubscription<LocationResult> _locationSubscription;
  double _currentLat;
  double _currentLng;

  bool _backgroundEnabled = false;

  @override
  void dispose() {
    super.dispose();
    if (!_backgroundEnabled) _locationSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();

    _locationSubscription = Geolocation.locationUpdates(
            accuracy: LocationAccuracy.block,
            displacementFilter: 20.0,
            inBackground: true)
        .listen((result) {
      setState(() {
        _currentLat = result.location.latitude;
        _currentLng = result.location.longitude;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Social Distancing")),
        body: Map(getCoords: () => LatLng(_currentLat, _currentLng)));
  }
}

class Map extends StatefulWidget {
  LatLng Function() getCoords;
  Map({Key key, this.getCoords}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return widget.getCoords().latitude != null
        ? GoogleMap(
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.getCoords(),
              zoom: 11.0,
            ),
          )
        : Container();
  }
}
