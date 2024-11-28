import 'package:flutter/material.dart';
import 'package:weatherapp/homepage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Default theme is light
  bool isDarkMode = true;

  // Toggle theme when button is pressed
  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Switch between light and dark theme
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Homepage(
        isDarkMode: isDarkMode,
        toggleTheme: toggleTheme, // Pass toggle function to Homepage
      ),
    );
  }
}



