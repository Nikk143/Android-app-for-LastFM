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
  const Recentplays({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = LastFM(dotenv.env['USERNAME'], dotenv.env['API_KEY']);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: defaultTheme,
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: FutureBuilder<Map<String, dynamic>?>(
          future: user.getRecentPlays(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Text(
                'Error fetching current track.',
              );
            } else {
              final apiData = snapshot.data!;
              final recentTracks = apiData['recenttracks'];

              return Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    (isTrackCurrentlyPlaying(recentTracks))
                        ? Container(
                            margin: const EdgeInsets.only(top: 30),
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.9,
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .shadow
                                      .withOpacity(0.4),
                                  spreadRadius: 2.5,
                                  blurRadius: 8,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Currently Playing: \n${recentTracks['track'][0]['name']} - ${recentTracks['track'][0]['artist']['#text']}',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          )
                        : Container(),
                    Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .shadow
                                .withOpacity(0.4),
                            spreadRadius: 2.5,
                            blurRadius: 8,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              overflow: TextOverflow.ellipsis,
                            ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text('Recently played:'),
                              ),
                            Text('1. ${recentTracks['track'][1]['name']}'),
                            Text('2. ${recentTracks['track'][2]['name']}'),
                            Text('3. ${recentTracks['track'][3]['name']}'),
                            Text('4. ${recentTracks['track'][4]['name']}'),
                            Text('5. ${recentTracks['track'][5]['name']}'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  bool isTrackCurrentlyPlaying(Map<String, dynamic> recentTracks) {
    try {
      return recentTracks['track'][0]['@attr']['nowplaying'] == 'true';
    } catch (e) {
      return false;
    }
  }
}
