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
    return const MaterialApp(
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
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 28, 0, 15),
        body: Column(
          children: [
            Align(
                child: Container(
              alignment: Alignment.topCenter,
              height: 100,
              width: 350,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 173, 26, 16),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // Shadow color
                    spreadRadius: 1, // How far the shadow should spread
                    blurRadius: 4, // How blurry the shadow should be
                    offset: Offset(5, 5), // Shadow offset (x, y)
                  ),
                ],
              ),
              child: FutureBuilder<Map<String, dynamic>?>(
                future: user.getRecentPlays(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return const Text('Failed to fetch data.');
                  } else {
                    final apiData = snapshot.data!;
                    final recentTracks = apiData['recenttracks'];

                    try {
                      if (recentTracks['track'][0]['@attr']['nowplaying'] ==
                          'true') {
                        final track = recentTracks['track'][0]['name'];
                        final artist =
                            recentTracks['track'][0]['artist']['#text'];
                        return Center(
                          child: Text(
                            'Currently Playing: \n$track - $artist',
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                    } catch (e) {}
                    return const Text('Nothing being played.');
                  }
                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}
