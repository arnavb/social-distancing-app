import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      home: BuildScreen(),
    );
  }
}

class BuildScreen extends StatefulWidget {
  @override
  _BuildScreenState createState() => _BuildScreenState();
}

class _BuildScreenState extends State<BuildScreen> {
  static const _messages = ["Stay Safe","Social Distance", "If you can\nStay Home","The Carona Virus can\n stay on a surface\n up to 3 days", "Wash your Hands\nfor 20 seconds","Keep Healthy when at Home","Limit your food Sharing","Avoid Crowding","Wear a Mask\nwhen outside","Wear gloves\nwhen outside","Don't Handshake", "Frequently Wash\n Your Hands"];
  static final messageLength = _messages.length;
  var rng = new Random();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double _circlePlace = height * .8;
      return Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/GrayScaleSpaceBackround.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4), BlendMode.dstATop)))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 350,
                height: 350,
                child: Image.asset('assets/images/CaronaPicture.png'),
              )
            ],
          ),
          Positioned(
            top: _circlePlace,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Text( "\n" + _messages[rng.nextInt(messageLength)], style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                )
              ],
            ),
          )
        ]),
      );
  }
}
