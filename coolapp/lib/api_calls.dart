import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> fetchData(username, apiKey) async {
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
