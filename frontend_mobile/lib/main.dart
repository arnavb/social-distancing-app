import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocation/geolocation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:floating_search_bar/floating_search_bar.dart';


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

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => LocationModel(),
      )
    ], child: AppContainer()));

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
            accuracy: LocationAccuracy.best,
            displacementFilter: 0.0,
            inBackground: true)
        .listen((result) {
      Provider.of<LocationModel>(context, listen: false).locationList = [
        result.location.latitude,
        result.location.longitude
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Social Distancing")), body: Map());
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController mapController;
  String _mapStyle;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style_dark.json').then((result) {
      _mapStyle = result;
    });
  }

  void _updateMap() {
    LatLng newLoc = Provider.of<LocationModel>(context, listen: false).location;

    if (newLoc != null)
      mapController.animateCamera(CameraUpdate.newLatLng(newLoc));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
    Provider.of<LocationModel>(context, listen: false).addListener(_updateMap);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationModel>(builder: (context, location, child) {
      return location.location != null
          ? SlidingUpPanel(
              body: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: location.location,
                  zoom: 15.0,
                ),
              ),
              panel: Center(
                child: Text(
                  "This is the Widget behind the sliding panel",
                ),
              ),
              backdropEnabled: true,
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0)),
            )
          : Center(child: CircularProgressIndicator());
    });
  }
}
