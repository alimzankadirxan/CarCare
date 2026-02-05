import 'package:flutter/material.dart';
import 'dart:ui'; // Для эффекта размытия (Blur)

import 'package:car_care/models/car_model.dart';
import 'package:car_care/configs/car_config.dart';
import 'package:car_care/services/post_service.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Car) {
      return const Scaffold(
        body: Center(child: Text("Ошибка: Данные автомобиля не переданы")),
      );
    }

    final Car car = args;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1013), // Глубокий темный фон
      body: CustomScrollView(
        slivers: [
          // 1. Красивый AppBar, который сворачивается
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: const Color(0xFF0F1013),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(car.name.toUpperCase(), 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2)),
              background: Hero(
                tag: car.name,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(car.image, fit: BoxFit.cover),
                    // Градиент поверх фото, чтобы текст читался
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xFF0F1013)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Контентная часть
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Блок ХАРАКТЕРИСТИКИ в стиле Glassmorphism
                  _buildSectionTitle("ХАРАКТЕРИСТИКИ"),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: car.specs.map((spec) => _buildGlassChip(spec)).toList(),
                  ),

                  const SizedBox(height: 40),
                  _buildSectionTitle("СЕРВИСНЫЙ ПЛАН"),
                  const SizedBox(height: 15),

                  // Список расходников в виде премиум-карт
                  ...car.consumables.map((c) => _buildConsumableCard(c)).toList(),

                  const SizedBox(height: 40),
                  _buildSectionTitle("МАРКЕТПЛЕЙС ЗАПЧАСТЕЙ"),
                  const SizedBox(height: 15),

                  // Блок цен из API в темном стиле
                  _buildPriceList(car.name),
                  
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Заголовок секции
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(width: 4, height: 20, color: CarConfig.accentNeon),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  // Стеклянный чип
  Widget _buildGlassChip(String label) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ),
      ),
    );
  }

  // Премиальная карточка расходника
  Widget _buildConsumableCard(Consumable c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1D22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orangeAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bolt, color: Colors.orangeAccent, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(c.recommendation, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
              ],
            ),
          ),
          Text(c.interval, style: TextStyle(color: CarConfig.accentNeon, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPriceList(String carName) {
    return FutureBuilder<List<Product>>(
      future: fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Text('Не удалось загрузить цены', style: TextStyle(color: Colors.white24));
        }

        final parts = snapshot.data!.take(3).toList();

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1D22),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: parts.map((p) => ListTile(
              leading: const Icon(Icons.shopping_bag_outlined, color: Colors.blueAccent),
              title: Text(p.title, style: const TextStyle(color: Colors.white, fontSize: 14), maxLines: 1),
              trailing: Text('${p.price} \$', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
            )).toList(),
          ),
        );
      },
    );
  }
}