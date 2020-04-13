import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/widgets/sliding_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:search_map_place/search_map_place.dart' hide Geolocation;
import 'package:frontend_mobile/models/location_model.dart';
import 'package:geolocation/geolocation.dart';
import 'package:frontend_mobile/.env.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  StreamSubscription<LocationResult> _locationSubscription;
  Completer<GoogleMapController> mapController = Completer();
  bool _backgroundEnabled = false;
  String _mapStyle;
  LatLng _selectedLocation;

  @override
  void dispose() {
    super.dispose();
    if (!_backgroundEnabled) _locationSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style_dark.json').then((result) {
      _mapStyle = result;
    });

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
    return Scaffold(
      body: Consumer<LocationModel>(builder: (context, location, child) {
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
                      apiKey: environment["googleApiKey"],
                      location: LatLng(0, 0),
                      radius: 3000,
                      onSelected: (place) async {
                        final geolocation = await place.geolocation;
                        final controller = await mapController.future;

                        controller.animateCamera(
                            CameraUpdate.newLatLng(geolocation.coordinates));
                        controller.animateCamera(CameraUpdate.newLatLngBounds(
                            geolocation.bounds, 0));
                        _selectedLocation = geolocation.coordinates;
                      },
                    ),
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator());
      }),
    );
  }
}
