import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textSize = size.width * 0.045; // адаптивный размер шрифта

    final consumables = [
      'Масло моторное',
      'Фильтр воздушный',
      'Фильтр масляный',
      'Свечи зажигания',
      'Тормозные колодки',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Расходники')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: consumables.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                consumables[index],
                style: TextStyle(fontSize: textSize),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/specs');
              },
            ),
          );
        },
      ),
    );
  }
}
