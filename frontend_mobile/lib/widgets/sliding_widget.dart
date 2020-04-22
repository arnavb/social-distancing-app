import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/location_model.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_mobile/.env.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[SomeTable()],
            ),
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

class SomeTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      columnWidths: {
        0: FractionColumnWidth(40.0),
        1: FractionColumnWidth(40.0)
      },
      children: <TableRow>[
        TableRow(children: <Widget>[Text("One person's"), Text("Joe")]),
        TableRow(children: <Widget>[Text("Another person's"), Text("Mama")])
      ],
    );
  }
}
