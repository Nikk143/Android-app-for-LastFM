import 'package:http/http.dart' as http;
import 'dart:convert';

class LastFM {
  dynamic username;
  dynamic apiKey;

  LastFM(this.username, this.apiKey);

  bool responseErrorCheck(http.Response response) {
    if (response.statusCode == 200) {
      print("Successful api fetch.");
      return true;
    } else {
      print("Error fetching from api.");
    }
    return false;
  }

  Future<Map<String, dynamic>?> getRecentPlays({int? unixTime}) async {
    final Map<String, String> queryParameters = {
      'method': 'user.getrecenttracks',
      'user': username.toString(),
      'api_key': apiKey.toString(),
      'format': 'json',
    };

    // Add 'from' parameter if provided
    if (unixTime != null) {
      queryParameters['from'] = unixTime.toString();
    }

    final Uri url = Uri.https(
      'ws.audioscrobbler.com',
      '/2.0/',
      queryParameters,
    );

    final response = await http.get(url);

    // Handle non-200 response status
    if (response.statusCode != 200) {
      print('Request failed with status: ${response.statusCode}');
      return null;
    }

    final utf8Response = utf8.decode(response.bodyBytes);

    return responseErrorCheck(response) ? json.decode(utf8Response) : null;
  }

  Future<Map<String, dynamic>?> getTopArtists() async {
    final url = Uri.parse(
        'http://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=$username&api_key=$apiKey&format=json');

    final response = await http.get(url);
    final utf8Response = utf8.decode(response.bodyBytes);
    return responseErrorCheck(response)
        ? json.decode(utf8Response)
        : Future.value(null);
  }
}
