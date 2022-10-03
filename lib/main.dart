import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyToDoLstApp());
}

class MyToDoLstApp extends StatelessWidget {
  const MyToDoLstApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      debugShowCheckedModeBanner: false,
      //app themes
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      //Routing to handel the navigation
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}
