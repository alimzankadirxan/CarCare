import 'package:flutter/material.dart';

// Импорты твоих существующих экранов
import 'package:car_care/screens/home_screen.dart';
import 'package:car_care/screens/detail_screen.dart';
import 'package:car_care/screens/my_car_screen.dart';
import 'package:car_care/screens/posts_screen.dart';

// Импорт нового экрана авторизации
import 'package:car_care/screens/auth_screen.dart'; 

void main() => runApp(const CarCareApp());

class CarCareApp extends StatelessWidget {
  const CarCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Care',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
        brightness: Brightness.dark, // Сделаем общую тему темной под стиль конфига
      ),
      // Стартовая точка — сплэш-скрин
      home: const SplashScreen(), 
      
      // Карта маршрутов (Navigation Routes)
      routes: {
        '/auth': (context) => const AuthScreen(),   // Экран входа/регистрации
        '/home': (context) => const HomeScreen(),   // Главный экран
        '/detail': (context) => const DetailScreen(),
        '/my_car': (context) => const MyCarScreen(),
        '/posts': (context) => const PostsScreen(),
      },
    );
  }
}

// Экран загрузки (Splash Screen)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Имитация загрузки 2 секунды
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // ИЗМЕНЕНИЕ: Теперь после загрузки идем на /auth, а не на /home
        Navigator.pushReplacementNamed(context, '/auth');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1D), // Твой основной темный цвет
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Твоя иконка авто
            const Icon(
              Icons.directions_car_filled, 
              size: 100, 
              color: Color(0xFF00ADB5) // accentBlue из твоего конфига
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECCA3)), // accentNeon
            ),
            const SizedBox(height: 20),
            const Text(
              "CAR CARE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}