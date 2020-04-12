import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

const String SOCIAL_DISTANCING_API_LOCATION = "https://sd-1000.appspot.com/";

class SlidingWidget extends StatelessWidget {
  ScrollController _controller;
  SlidingWidget(this._controller);

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
              children: <Widget>[
                FutureBuilder(
                    future: http.get(SOCIAL_DISTANCING_API_LOCATION),
                    builder: (context, snapshot) {
                      try {
                        if (snapshot.hasData) {
                          return Text(snapshot.data.toString());
                        }
                      } finally {
                        return CircularProgressIndicator();
                      }
                    })
              ],
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ));
  }
}
