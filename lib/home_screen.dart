import 'package:flutter/material.dart';
import 'car_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем ширину экрана
    double screenWidth = MediaQuery.of(context).size.width;
    
    // Определяем количество колонок в зависимости от ширины
    int crossAxisCount = screenWidth > 1200 ? 3 : (screenWidth > 800 ? 2 : 1);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('CARCARE GARAGE', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center( // Центрируем контент
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400), // Ограничиваем макс. ширину
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.8, // Соотношение сторон карточки
            ),
            itemCount: myGarage.length,
            itemBuilder: (context, index) {
              final car = myGarage[index];
              return _buildCarCard(context, car);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, Car car) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: car),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4))],
          image: DecorationImage(
            image: car.image.startsWith('http') ? NetworkImage(car.image) : AssetImage(car.image) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(car.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(car.description, style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}