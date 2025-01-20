import 'package:flutter/material.dart';
import 'package:machinetest/Screens/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Set the scaffold background color to black
        scaffoldBackgroundColor: Colors.black,
        
        // Customize the color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          background: Colors.black, // Set the general background to black
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
        
        ),
      ),
      home:  Home(),
    );
  }
}
