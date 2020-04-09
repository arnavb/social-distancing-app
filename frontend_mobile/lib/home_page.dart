import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              if (true)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("SHM"),
                ),
              RaisedButton(
                  child: Text("Get User Location"),
                  onPressed: _getCurrentLocation)
            ],
          ),
        ));
  }

  void _getCurrentLocation() {}
}
