import 'package:flutter/material.dart';
import 'api_calls.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final user = LastFM(dotenv.env['USERNAME'], dotenv.env['API_KEY']);
    return MaterialApp(
      home: FutureBuilder<Map<String, dynamic>?>(
        future: user.getRecentPlays(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data, you can show a loading indicator.
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            // If there is an error or data is null, display an error message.
            return const Scaffold(
              body: Center(
                child: Text('Failed to fetch data.'),
              ),
            );
          } else {
            // If data is available, display it.
            final apiData = snapshot.data!;
            final artist =
                apiData['recenttracks']['track'][0]['artist']['#text'];

            return Scaffold(
              appBar: AppBar(
                title: Text(artist),
              ),
            );
          }
        },
      ),
    );
  }
}