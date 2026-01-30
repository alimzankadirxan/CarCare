import 'package:flutter/material.dart';
import 'car_model.dart';

class MyCarScreen extends StatelessWidget {
  const MyCarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final car = ModalRoute.of(context)!.settings.arguments as Car;
    double oilProgress = (car.mileage - car.lastOilChange) / 8000;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(car.name),
              background: Image(
                image: car.image.startsWith('http') ? NetworkImage(car.image) : AssetImage(car.image) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatRow('Общий пробег', '${car.mileage} км'),
                  const SizedBox(height: 25),
                  const Text('СОСТОЯНИЕ РАСХОДНИКОВ', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 15),
                  _buildProgressIndicator('Масло ДВС', oilProgress > 1.0 ? 1.0 : oilProgress, oilProgress > 0.9),
                  _buildProgressIndicator('Антифриз', 0.4, false), // Для примера
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {}, 
                    child: const Text('ОБНОВИТЬ ПРОБЕГ', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildProgressIndicator(String label, double value, bool isRed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          minHeight: 10,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: Colors.grey[300],
          color: isRed ? Colors.red : Colors.green,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}