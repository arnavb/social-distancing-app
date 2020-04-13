import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final config = {
    'apiUrl': Platform.environment['API_URL'],
    'googleApiKey': Platform.environment['GOOGLE_API_KEY']
  };

  final filename = 'lib/.env.dart';
  File(filename).writeAsString('final environment = ${json.encode(config)};');
}
