import 'package:flutter/material.dart';
import 'specs_screen.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passat CC')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/passat.png', height: 160),
            const SizedBox(height: 20),
            const Text(
              'Volkswagen Passat CC 2011 — стильный купе-седан с комфортным салоном и хорошей динамикой.',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SpecsScreen(),
                    ),
                  );
                },
                child: const Text('Характеристики'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
