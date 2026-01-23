import 'package:flutter/material.dart';

class SpecsScreen extends StatelessWidget {
  const SpecsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleSize = size.width * 0.06;
    final textSize = size.width * 0.045;

    return Scaffold(
      appBar: AppBar(title: const Text('Характеристики')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Характеристики автомобиля',
                style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text('Мощность: 220 л.с.', style: TextStyle(fontSize: textSize)),
              Text('Объем двигателя: 2.0 л', style: TextStyle(fontSize: textSize)),
              Text('Тип топлива: Бензин', style: TextStyle(fontSize: textSize)),
              const SizedBox(height: 30),
              SizedBox(
                width: size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Назад'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
