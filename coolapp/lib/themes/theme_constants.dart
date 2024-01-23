import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);

ThemeData defaultTheme = ThemeData(
  useMaterial3: true,
  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: TextTheme(
    displayMedium: GoogleFonts.poppins(
      fontSize: 18,
    ),
  ),

  colorScheme: const ColorScheme.dark(
    primary: Color.fromARGB(255, 173, 26, 16),
    shadow: Color.fromARGB(105, 255, 89, 0),
    background: Color.fromARGB(255, 28, 0, 15),
  ),
);
