import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

class BuildScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double _circlePlace = (height/2) + 190;
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
                Text(
                  "\nStay safe", style: TextStyle(color: Colors.white, fontSize: 20),
                )
              ],
            ),
          )
        ]),
      );
  }
}
