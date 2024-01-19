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

  Future<Map<String, dynamic>?> getRecentPlays() async {
    final url = Uri.parse(
        'http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=$username&api_key=$apiKey&format=json');
    final response = await http.get(url);
    return responseErrorCheck(response)
        ? json.decode(response.body)
        : Future.value(null);
  }

  Future<Map<String, dynamic>?> getTopArtists() async {
    final url = Uri.parse(
        'http://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=$username&api_key=$apiKey&format=json');

    final response = await http.get(url);
    return responseErrorCheck(response)
        ? json.decode(response.body)
        : Future.value(null);
  }
}
