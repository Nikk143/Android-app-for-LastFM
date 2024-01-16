import 'package:flutter/material.dart';
import 'api_calls.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<Map<String, dynamic>?>(
        future: fetchData(),
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