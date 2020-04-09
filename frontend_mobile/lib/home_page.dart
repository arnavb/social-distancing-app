import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocation/geolocation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Switch(
                value: _backgroundEnabled,
                onChanged: (bool newVal) =>
                    setState(() => _backgroundEnabled = newVal),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(_currentLat == null || _currentLng == null
                      ? "Unkown"
                      : "${_currentLat} ${_currentLng}"))
            ],
          ),
        ));
  }
}
