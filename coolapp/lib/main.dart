import 'package:flutter/material.dart';
import 'api_calls.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

Future main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Recentplays(),
      ),
    );
  }
}

class Recentplays extends StatelessWidget {
  const Recentplays({super.key});

  @override
  Widget build(BuildContext context) {
    final user = LastFM(dotenv.env['USERNAME'], dotenv.env['API_KEY']);
    return MaterialApp(
      home: FutureBuilder<Map<String, dynamic>?>(
        future: user.getRecentPlays(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Text('Failed to fetch data.');
          } else {
            final apiData = snapshot.data!;
            final recentTracks = apiData['recenttracks'];

            if (recentTracks['track'][0]['@attr']['nowplaying'] == 'true') {
              final track = recentTracks['track'][0]['name'];
              final artist = recentTracks['track'][0]['artist']['name'];
              return Text(
                  'Currently Playing: ${track} - ${artist}');
            }

            return const Text('Nothing being played.');
          }
        },
      ),
    );
  }
}
