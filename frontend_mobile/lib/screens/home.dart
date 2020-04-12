import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(buildScreen());

class buildScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(children: <Widget>[
        Container(
          color: Colors.white,
        ),
        Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://vignette.wikia.nocookie.net/memepediadankmemes/images/b/be/Spaghet.png/revision/latest/top-crop/width/360/height/450?cb=20180611153100'),
                    fit: BoxFit.cover))),
        Container(
          alignment: Alignment.topCenter,
          width: 500,
          height: 500,
          child: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/SARS-CoV-2_without_background.png/597px-SARS-CoV-2_without_background.png'),
        )
      ]),
    );
  }
}
