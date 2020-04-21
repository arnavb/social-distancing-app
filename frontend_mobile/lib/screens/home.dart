import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(BuildScreen());

class BuildScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Text(
                  "\nStay safe",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
