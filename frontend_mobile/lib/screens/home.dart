import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(BuildScreen());

class BuildScreen extends StatefulWidget {
  @override
  _BuildScreenState createState() => new _BuildScreenState();
}

class _BuildScreenState extends State<BuildScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
          Container(
            color: Colors.white,
          ),
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/GrayScaleSpaceBackround.jpg'),
                      fit: BoxFit.cover))),
          Positioned(
              right: 0,
              left: 3,
              top: 190,
              child: Container(
                width: 350,
                height: 350,
                child: Image.asset('assets/images/CaronaPicture.png'),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Text("Stay Safe \n and \n Social Distance")
                      ],
                    ),
                  ))
            ],
          ),
        ]),
      ),
    );
  }
}
