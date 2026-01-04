import 'package:flutter/material.dart';
import 'package:music_player/ui/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF5D4DCB),
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF5D4DCB),
          secondary: Color(0xFF5D4DCB),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      home: Register(),
    );
  }
}
