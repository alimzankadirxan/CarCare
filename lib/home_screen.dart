import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // размеры экрана
    final imageHeight = size.height * 0.3; // 30% от высоты экрана
    final buttonWidth = size.width * 0.6;  // 60% ширины экрана

    return Scaffold(
      appBar: AppBar(title: const Text('Главная — CarCare')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Volkswagen Passat CC',
                style: TextStyle(
                  fontSize: size.width * 0.06, // адаптивный шрифт
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/passat.png',
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/detail');
                  },
                  child: const Text('Посмотреть расходники'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
