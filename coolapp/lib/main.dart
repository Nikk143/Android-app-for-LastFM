import 'package:coolapp/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'api_calls.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'themes/theme_constants.dart';

Future main() async {
  await dotenv.load();
  runApp(const MyApp());
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: defaultTheme,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // backgroundColor: Color.fromARGB(255, 28, 0, 15),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            Align(
              child: Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 30),
                height: 100,
                width: 350,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  // const Color.fromARGB(255, 173, 26, 16)
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.shadow.withOpacity(0.4),
                      spreadRadius: 2.5,
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: user.getRecentPlays(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return const Text(
                        'Failed to fetch data.',
                      );
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
