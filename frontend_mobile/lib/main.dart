import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_mobile/models/location_model.dart';
import 'package:frontend_mobile/screens/map.dart';


void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => LocationModel(),
      )
    ], child: App()));

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primaryColor: Colors.white),
        darkTheme: ThemeData.dark(),
        home: Map());
  }
}

