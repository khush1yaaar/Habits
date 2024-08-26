import 'package:flutter/material.dart';
import 'package:habits/database/habit_database.dart';
import 'package:habits/pages/home_page.dart';
import 'package:habits/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HabitDatabase()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: FutureBuilder(
        future: initializeDatabase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while the database is initializing
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            // Handle any errors that occurred during initialization
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            // Once initialization is complete, show the home page
            return const HomePage();
          }
        },
      ),
    );
  }

  Future<void> initializeDatabase() async {
    try {
      await HabitDatabase.initialize();
      await HabitDatabase.saveFirstLaunchDate();
      print('HABIT DATABASE IS INITIALIZED');
    } catch (e) {
      print('ERROR INITIALIZING DATABASE: $e');
      rethrow; // Rethrow the error so that FutureBuilder can catch it
    }
  }
}
