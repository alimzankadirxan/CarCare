import 'package:flutter/material.dart';

class SpecsScreen extends StatelessWidget {
  const SpecsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Характеристики')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            Text('Двигатель: 1.8 TSI', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Мощность: 160 л.с.'),
            Text('Крутящий момент: 250 Н·м'),
            Text('Привод: передний'),
            Text('Разгон 0–100 км/ч: ~8.5 сек'),
            Text('Максимальная скорость: 220 км/ч'),
          ],
        ),
      ),
    );
  }
}
