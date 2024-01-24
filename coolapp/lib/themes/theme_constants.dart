import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);

final ThemeData defaultTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: Color.fromARGB(255, 173, 26, 16),
    shadow: Color.fromARGB(105, 255, 89, 0),
    background: Color.fromARGB(255, 28, 0, 15),
  ),
  textTheme: TextTheme(
    bodyMedium: GoogleFonts.poppins(fontSize: 17.0),
  ),
);
