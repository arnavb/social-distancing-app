import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocation/geolocation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<LocationResult> _locationSubscription;
  String _currentLocation = "Unknown";

  @override
  void dispose() {
    super.dispose();
    _locationSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();

    _locationSubscription = Geolocation.locationUpdates(
            accuracy: LocationAccuracy.best, inBackground: true)
        .listen((result) {
      setState(() {
        _currentLocation =
            "${result.location.latitude}, ${result.location.latitude}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Text(_currentLocation),
      ),
    );
  }
}
