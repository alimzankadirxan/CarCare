import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'detail_screen.dart';
import 'posts_screen.dart';

void main() => runApp(const CarCareApp());

class CarCareApp extends StatelessWidget {
  const CarCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blueGrey),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/detail': (context) => const DetailScreen(),
        '/posts': (context) => const PostsScreen(),
      },
    );
  }
}