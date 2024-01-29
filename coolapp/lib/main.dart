import 'package:coolapp/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'api_calls.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'themes/theme_constants.dart';
import 'package:intl/intl.dart';

Future main() async {
  await dotenv.load();
  runApp(const MyApp());
}

ThemeManager _themeManager = ThemeManager();
final user = LastFM(dotenv.env['USERNAME'], dotenv.env['API_KEY']);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: defaultTheme,
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Home(),
        ));
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    ReportsView(),
    OtherView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.primary),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Other',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Recentplays extends StatelessWidget {
  const Recentplays({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .shadow
                                    .withOpacity(0.2),
                                spreadRadius: 2.0,
                                blurRadius: 6,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/sound.gif',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '${recentTracks['track'][0]['name']} - ${recentTracks['track'][0]['artist']['#text']}',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .shadow
                                .withOpacity(0.2),
                            spreadRadius: 2.0,
                            blurRadius: 6,
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
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: const Text('Recently played:'),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                    child: Row(
                                      children: [
                                        // Adjust the right padding as needed
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Image.network(
                                            recentTracks['track'][index]
                                                    ['image'][0]['#text']
                                                .toString(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            ' ${recentTracks['track'][index]['name']}',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
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

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          Expanded(child: Recentplays()),
          Expanded(child: OverviewStats()),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset(
            'assets/lastfmlogo.png', // Replace with your image asset path
            width: 100, // Adjust width as needed
            height: 100, // Adjust height as needed
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Reports View'),
    );
  }
}

class OtherView extends StatelessWidget {
  const OtherView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Other View'),
    );
  }
}

class OverviewStats extends StatelessWidget {
  const OverviewStats({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime currentTime = DateTime.now().toLocal();
    DateTime time =
        DateTime(currentTime.year, currentTime.month, currentTime.day);
    int unixTime = (time.toUtc()).millisecondsSinceEpoch ~/ 1000;
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: user.getRecentPlays(unixTime: unixTime),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Text(
              'Error fetching recent plays: ${snapshot.error}',
            );
          } else {
            final apiData = snapshot.data!;
            final dailyScrobbles = apiData['recenttracks']['track'].length;

            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                      spreadRadius: 2.0,
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                    child: Column(
                  children: [
                    Text('Daily Scrobbles: $dailyScrobbles'),
                    Text(
                      'Top Artist: ${user.dailyTopArtist.keys.first} - ${user.dailyTopArtist[user.dailyTopArtist.keys.first]} plays',
                    ),
                  ],
                )),
              ),
            );
          }
        },
      ),
    );
  }
}
