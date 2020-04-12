import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/slider_content.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocation/geolocation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:search_map_place/search_map_place.dart' hide Geolocation;

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
    return Scaffold(body: Map());
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Completer<GoogleMapController> mapController = Completer();
  String _mapStyle;
  LatLng _selectedLocation;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style_dark.json').then((result) {
      _mapStyle = result;
    });
  }

  void _updateMap() async {
    LatLng newLoc = Provider.of<LocationModel>(context, listen: false).location;

    if (newLoc != null && _selectedLocation == null) {
      final controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newLatLng(newLoc));
    }
  }

  void _onMapCreated(GoogleMapController googleMapController) async {
    mapController.complete(googleMapController);
    final controller = await mapController.future;
    controller.setMapStyle(_mapStyle);
    Provider.of<LocationModel>(context, listen: false).addListener(_updateMap);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationModel>(builder: (context, location, child) {
      return location.location != null
          ? Stack(
              children: <Widget>[
                SlidingUpPanel(
                  parallaxEnabled: true,
                  parallaxOffset: 0.5,
                  body: GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: location.location,
                      zoom: 15.0,
                    ),
                  ),
                  panelBuilder: (sc) => SlidingWidget(sc),
                  backdropEnabled: true,
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0)),
                ),
                Positioned(
                  top: 60,
                  left: MediaQuery.of(context).size.width * 0.05,
                  child: SearchMapPlaceWidget(
                    apiKey: "",
                    location: LatLng(0, 0),
                    radius: 3000,
                    onSelected: (place) async {
                      final geolocation = await place.geolocation;
                      final controller = await mapController.future;

                      controller.animateCamera(
                          CameraUpdate.newLatLng(geolocation.coordinates));
                      controller.animateCamera(
                          CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                      _selectedLocation = geolocation.coordinates;
                    },
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator());
    });
  }
}
