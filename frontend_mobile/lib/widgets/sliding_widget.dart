import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/location_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_mobile/.env.dart';
import 'package:provider/provider.dart';

class SlidingWidget extends StatelessWidget {
  ScrollController _controller;
  LocationModel _location;
  SlidingWidget(this._controller, this._location);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: this._controller,
          children: <Widget>[
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            SizedBox(
              height: 18.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Details",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 18.0,
            ),
            NearbyTable(),
            SizedBox(
              height: 24,
            ),
          ],
        ));
  }
}

class Nearby extends StatefulWidget {
  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  Widget _prev = CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: http.get(environment["apiUrl"]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _prev = Text(snapshot.data.body);
            return _prev;
          } else {
            return _prev;
          }
        });
  }
}

class NearbyTable extends StatefulWidget {
  @override
  _NearbyTableState createState() => _NearbyTableState();
}

class _NearbyTableState extends State<NearbyTable> {
  Widget _prev = Center(
    child: Column(
      children: <Widget>[
        CircularProgressIndicator(),
        Text("Sorry, this takes time to load... Our backend is jank")
      ],
    ),
  );

  getNearbyPopularity() async {
    LatLng loc = Provider.of<LocationModel>(context, listen: false).location;
    String url =
        "${environment["apiUrl"]}area-popularity?lat=${loc.latitude}&lng=${loc.longitude}";
    //The reason this isn't working is because the futurebuilder runs every rerender(which happens when the map center is updated)
    //The API does not return within the rerender. The jank solution of remembering the previous widget in the state doesn't help this
    //Must find less jank solution
    return await http.get(url);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getNearbyPopularity(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _prev = Center(
                child: Container(
                    child: Table(
              border: TableBorder.symmetric(),
              columnWidths: {
                0: FractionColumnWidth(0.45),
                1: FractionColumnWidth(0.45)
              },
              children: <TableRow>[
                TableRow(
                    children: <Widget>[Text(snapshot.data.body), Text("Joe")]),
                TableRow(
                    children: <Widget>[Text("Another person's"), Text("Mama")])
              ],
            )));
            return _prev;
          } else {
            return _prev;
          }
        });
  }
}
