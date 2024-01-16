import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<String, dynamic>?> fetchData() async {
  await dotenv.load(fileName: '.env');
  var username = dotenv.env['USERNAME'];
  var apiKey = dotenv.env['API_KEY'];

  final url = Uri.parse(
      'https://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=$username&api_key=$apiKey&format=json');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    print("Successful api fetch.");
    return json.decode(response.body);
  } else {
    print("Error fetching from api.");
  }
  return null;
}
