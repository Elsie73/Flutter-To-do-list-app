import 'package:flutter/material.dart';
import 'package:todolist/screens/tasks_screen.dart'; // Importing the task_screen.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner for a clean UI
      title: 'ToDo List App', // Set a descriptive app title
      theme: ThemeData( // Configure app theme
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: const Color(0xFF883007)), // Set primary color
        useMaterial3: true, // Enable Material 3 design elements for a modern look
      ),
      home: const SplashScreen(), // Set initial screen to SplashScreen for a professional look
      routes: {
        '/home': (context) => TasksScreen(), // Define route for TasksScreen
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Navigate to TasksScreen after a delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });

    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to ToDo List App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}